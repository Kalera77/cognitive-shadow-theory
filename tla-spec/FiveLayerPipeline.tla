------------------------------ MODULE FiveLayerPipeline ------------------------------
EXTENDS Integers, Sequences, FiniteSets, TLC

CONSTANTS
    MaxQueue,       \* максимум событий в очереди (слой 1)
    MaxWindow,      \* максимум семантических состояний в окне (слой 2)
    NumPids,        \* число отслеживаемых процессов
    TTL,            \* время жизни карантина (слой 5)
    H_min,          \* минимальная осмысленная энтропия (слой 3, scale=100)
    H_alert,        \* порог WARNING
    H_critical,     \* порог CRITICAL
    M_min           \* минимальное число различных состояний

VARIABLES
    queue,          \* L1: события, ждущие сжатия (последовательность pid)
    window,         \* L2: окно семантических состояний
    H0,             \* L3: текущая энтропия (масштаб ×100)
    M,              \* L3: число различных состояний
    alert_level,    \* L4: "NORMAL" | "WARNING" | "CRITICAL"
    quarantined,    \* L5: pids в карантине
    ttl,            \* L5: pid -> оставшиеся тики
    last_action     \* для трассировки

vars == <<queue, window, H0, M, alert_level, quarantined, ttl, last_action>>

(* ============================================================
   LAYER 1: Event Capture
   ============================================================ *)
L1_Capture(pid) ==
    /\ pid \in 1..NumPids
    /\ Len(queue) < MaxQueue
    /\ queue' = Append(queue, pid)
    /\ UNCHANGED <<window, H0, M, alert_level, quarantined, ttl>>
    /\ last_action' = "Capture"

(* ============================================================
   LAYER 2: Semantic Compression
   ============================================================ *)
L2_Compress ==
    /\ Len(queue) > 0
    /\ window' = ( IF Len(window) < MaxWindow
                   THEN Append(window, Head(queue))
                   ELSE Append(Tail(window), Head(queue)) )
    /\ queue' = Tail(queue)
    /\ UNCHANGED <<H0, M, alert_level, quarantined, ttl>>
    /\ last_action' = "Compress"

\* L3+L4: атомарное обновление энтропии и пересчёт уровня.
\* Разделение приводило к окну несогласованности (H0 обновлён,
\* alert_level — нет), что нарушало Inv_AlertConsistent.
\* В реальной архитектуре эти два этапа логически едины:
\* после пересчёта окна сразу определяется уровень риска.
L3_L4_UpdateAndDetect ==
    /\ window /= <<>>
    /\ LET newM == Cardinality({ window[i] : i \in 1..Len(window) })
           newH0 == newM * 100
           newLevel ==
               IF newH0 < H_critical /\ newM < M_min
                 THEN "CRITICAL"
               ELSE IF newH0 < H_alert /\ newM < M_min + 1
                 THEN "WARNING"
               ELSE "NORMAL"
       IN
       /\ M' = newM
       /\ H0' = newH0
       /\ alert_level' = newLevel
    /\ UNCHANGED <<queue, window, quarantined, ttl>>
    /\ last_action' = "UpdateAndDetect"

(* ============================================================
   LAYER 5a: Reversible Isolation — Quarantine
   ============================================================ *)
L5_Quarantine(pid) ==
    /\ alert_level = "CRITICAL"
    /\ pid \in 1..NumPids
    /\ pid \notin quarantined
    /\ quarantined' = quarantined \cup {pid}
    /\ ttl' = [ttl EXCEPT ![pid] = TTL]
    /\ UNCHANGED <<queue, window, H0, M, alert_level>>
    /\ last_action' = "Quarantine"

(* ============================================================
   LAYER 5b: TTL tick — automatic release
   ============================================================ *)
L5_Tick ==
    /\ quarantined /= {}
    /\ LET new_ttl == [ p \in 1..NumPids |->
                         IF p \in quarantined
                         THEN ttl[p] - 1
                         ELSE 0 ]
           expired == { p \in quarantined : new_ttl[p] = 0 }
       IN
       /\ ttl'         = new_ttl
       /\ quarantined' = quarantined \ expired
    /\ UNCHANGED <<queue, window, H0, M, alert_level>>
    /\ last_action' = "Tick"

(* ============================================================
   LAYER 5c: Explicit release — reversibility guarantee
   ============================================================ *)
L5_Release(pid) ==
    /\ pid \in quarantined
    /\ quarantined' = quarantined \ {pid}
    /\ ttl' = [ttl EXCEPT ![pid] = 0]
    /\ UNCHANGED <<queue, window, H0, M, alert_level>>
    /\ last_action' = "Release"

(* ============================================================
   Next-state relation
   ============================================================ *)
Next ==
    \/ \E pid \in 1..NumPids : L1_Capture(pid)
    \/ L2_Compress
    \/ L3_L4_UpdateAndDetect
    \/ \E pid \in 1..NumPids : L5_Quarantine(pid)
    \/ L5_Tick
    \/ \E pid \in 1..NumPids : L5_Release(pid)

\* WF для L5_Quarantine: если система в состоянии CRITICAL и есть
\* pid, доступный для карантина, то карантин обязан рано или поздно
\* произойти. Без этого liveness нарушается: система может обнаружить
\* CRITICAL и проигнорировать его (stuttering).
Fairness ==
    /\ WF_vars(L2_Compress)
    /\ WF_vars(L3_L4_UpdateAndDetect)
    /\ WF_vars(L5_Tick)
    /\ WF_vars(\E pid \in 1..NumPids : L5_Quarantine(pid))

Init ==
    /\ queue = <<>>
    /\ window = <<>>
    /\ M = M_min
    /\ H0 = M_min * 100
    /\ alert_level = "WARNING"
    /\ quarantined = {}
    /\ ttl = [p \in 1..NumPids |-> 0]
    /\ last_action = "Init"

Spec == Init /\ [][Next]_vars /\ Fairness

(* ============================================================
   INVARIANTS
   ============================================================ *)

\* L1: очередь не переполняется
Inv_QueueBounded == Len(queue) <= MaxQueue

\* L2: окно не переполняется
Inv_WindowBounded == Len(window) <= MaxWindow

\* L3: энтропия и M неотрицательны, H0 кратно 100
Inv_EntropyNonNeg == H0 >= 0
Inv_MNonNeg == M >= 0
Inv_H0DerivedFromM == H0 = M * 100

\* L4: alert_level согласован с H0/M
Inv_AlertConsistent ==
    (alert_level = "CRITICAL" => (H0 < H_critical /\ M < M_min)) /\
    (alert_level = "WARNING"  => (H0 < H_alert    /\ M < M_min + 1))

\* L5: каждый карантин имеет TTL в границах [0, TTL]
Inv_QuarantineHasTTL ==
    \A p \in quarantined : ttl[p] <= TTL /\ ttl[p] >= 0

\* L5: TTL != 0 только у карантинированных
Inv_TTLOnlyForQuarantined ==
    \A p \in 1..NumPids : p \notin quarantined => ttl[p] = 0

\* last_action строго из известного множества
Inv_LastActionDefined ==
    last_action \in {"Init","Capture","Compress","UpdateAndDetect",
                     "Quarantine","Tick","Release"}

SafetyInvariant ==
    /\ Inv_QueueBounded
    /\ Inv_WindowBounded
    /\ Inv_EntropyNonNeg
    /\ Inv_MNonNeg
    /\ Inv_H0DerivedFromM
    /\ Inv_AlertConsistent
    /\ Inv_QuarantineHasTTL
    /\ Inv_TTLOnlyForQuarantined
    /\ Inv_LastActionDefined

(* ============================================================
   TEMPORAL PROPERTIES
   ============================================================ *)

\* Обратимость: каждый карантин рано или поздно снимается.
\* Если pid попал в quarantined, то рано или поздно он из него выйдет
\* (либо через L5_Tick по TTL, либо через L5_Release).
Liveness_Reversibility ==
    \A p \in 1..NumPids :
        []( (p \in quarantined) => <>(p \notin quarantined) )

\* Прогресс алерта: если уровень CRITICAL, система либо выходит из него,
\* либо активирует карантин.
Liveness_CriticalHandled ==
    []( (alert_level = "CRITICAL")
        => <>( (alert_level /= "CRITICAL") \/ (quarantined /= {}) ) )

====