# Теория когнитивной тени: формальные пределы оцифровки сознания

**Автор:** Калинин Валерий Сергеевич  
**ORCID:** [0009-0003-0610-5137](https://orcid.org/0009-0003-0610-5137)  
**Контакт:** kalera77@gmail.com  
**Версия:** v3.2 (ноябрь 2026)  
**Релиз:** [github.com/Kalera77/cognitive-shadow-theory/releases/tag/v3.2](https://github.com/Kalera77/cognitive-shadow-theory/releases/tag/v3.2)

---

## 📖 О проекте

Теория когнитивной тени устанавливает **формальные пределы полной оцифровки сознания**. Любая вычислительная система, претендующая на исчерпывающее формальное представление познающего агента, неизбежно оставляет неформализуемый остаток — когнитивную тень.

### Ключевые результаты

**Эмпирика:**
- **AUC = 0.947** для детекции LIS vs healthy (GroupKFold)
- **AUC = 0.887** при кросс-популяционной валидации (Random Forest + SMOTE)
- **Специфичность подтверждена:** AUC ≈ 0.5 для контрольных задач (сон, пол, эпилепсия)
- **Параметр A (Awareness)** подтверждён (p = 0.045)
- **Теорема 10:** AUC любого классификатора сознания ∈ (0.5, 1)

**Формальная верификация:**
- **Coq 8.18+:** 43 модуля, **0 `admit`, 0 ошибок** (`src/`)
- **TLA⁺ 2.19 (TLC):** 225 000 различных состояний, глубина 22, **без нарушений инвариантов, без deadlock** (`tla-spec/`)
- **3 из 4 SDT-мостов доказаны** как теоремы (immiseration→P2, elite→P2, fiscal→P3); 1 мост-аксиома (SG→P6) документирован в `EXTENSIONS/Microfoundations_for_SDT.md` §6.10

### Структура репозитория

- `THEORY/` — теоретическое ядро (аксиомы, теоремы, философские основания)
  - `EXTENSION_MAP.md` — обзор уровней формализации L1–L4
  - `UNIVERSALITY_OF_THEOREMS.md`
- `EMPIRICAL/` — эмпирическая валидация (статья, приложения, экспериментальная программа)
  - `Appendix_S7_SG_Data_Collection.md` — методология сбора данных и калибровка SG(t) (§5bis)
- `ETHICS/` — этические принципы Shadow Ethics v3
  - `specification/` — формальная спецификация
  - `clinical/` — FORCED_REPORT и клинические приложения
  - `meta/` — метаэтическое обоснование
  - `narrative/` — философский нарратив
  - `archive/` — ранние версии (DEPRECATED, см. git history)
- `EXTENSIONS/` — расширения: SDT-микрооснования через теорию когнитивной тени (`Microfoundations_for_SDT.md`)
- `ESSAYS/` — сборник архитектурных эссе «Тень и её маски»
  - `shadow_masks_genius_vanity_addiction.md`
  - `shadow_masks_dynamics_resources.md`
  - `shadow_masks_civilization.md`
- `src/` — формальные доказательства Coq (43 модуля, 0 `admit`, 0 ошибок)
  - `src/Quantum/`, `src/Phenomenological/`, `src/Principles/`,
    `src/Complexity/`, `src/HigherHilbert/`, `src/Expansion/` — ядро теории
  - `src/Ethics/` — этика v3 (9 модулей: Foundations, Relational, Arbitration,
    ProxyConsent, Operator, Alignment, MultiAgent, ForcedReportDecision_v3, ClinicalAudit)
  - `src/Extensions/` — `ShadowEthicsInvariants.v`, `SDTMicrofoundations.v`
- `tla-spec/` — TLA⁺ спецификации инвариантов Shadow Ethics
  - `ShadowEthicsInvariants.tla` — v2.0 (consent-aware, per-agent P6, CloneKind для P1)
  - `ShadowEthicsInvariants.cfg` — конфигурация TLC
  - `logs/` — логи верификации (см. `.gitignore` для build artifacts)
- `reports/` — результаты анализа и графики
- `docs/` — сопроводительные документы

### Как воспроизвести верификацию

**Coq:**
```bash
docker-compose run --rm coq
# или локально:
coq_makefile -f _CoqProject -o Makefile && make -j$(nproc)
Ожидание: 43 модуля компилируются, 0 admit, 0 ошибок.

TLA⁺ (TLC):

bash
java -XX:+UseParallelGC -jar tla-spec/tla2tools.jar \
    tla-spec/ShadowEthicsInvariants.tla \
    *> tla-spec/logs/ShadowEthicsInvariants.log
Ожидание: Model checking completed. No error has been found. (225 000 различных состояний, глубина 22).

🔒 Политика доступа
1. Научное использование (бесплатно, без NDA)
Вся теоретическая документация, эмпирика, этика, формальные доказательства Coq, TLA⁺

Лицензия: CC BY-NC 4.0 (тексты) + MIT (код)

Обязательное цитирование

2. Некоммерческое исследование (бесплатно, с NDA)
Реализация алгоритмов, калибровочные константы, обученные модели

Требуется подписание NDA (шаблон: см. раздел «Запрос доступа»)

3. Коммерческое использование (платно, с лицензией)
Использование FORCED_REPORT в коммерческих продуктах

Требуется лицензионное соглашение и оплата роялти

4. Клиническое партнёрство (бесплатно, с соглашением)
Участие в проспективных клинических испытаниях

Требуется подписание соглашения о сотрудничестве и IRB

5. Патентная защита
Патентная заявка RU 2026XXXXXX подана 2 июля 2026 г.

Формула из 18 пунктов, 3 независимых способа

Все коммерческие материалы защищены патентным правом

📝 Запрос доступа
Email: kalera77@gmail.com
Темы писем:

NDA for research access — для некоммерческого исследования

Commercial license inquiry — для коммерческого использования

Clinical partnership — для клинической валидации

🤝 Приглашение к сотрудничеству
Приглашаем нейробиологов, клиницистов, математиков, философов, инженеров и этиков к развитию теории.

Цитирование:

bibtex
@techreport{kalinin2026cognitive-shadow,
  title = {Теория когнитивной тени: формальные пределы оцифровки сознания},
  author = {Калинин, Валерий Сергеевич},
  year = {2026},
  month = {November},
  version = {3.2},
  url = {https://github.com/Kalera77/cognitive-shadow-theory},
  note = {v3.2: 43 Coq modules (0 admit), TLA+ verified (225,000 states)}
}
Лицензия: тексты — CC BY-NC 4.0; формальные доказательства — MIT.