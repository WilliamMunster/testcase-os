---
name: knowledge-import
description: Import business knowledge from various sources into the knowledge base. Triggers on "import knowledge", "add domain knowledge", "import from Confluence", "save this as knowledge", "import business rules", "add knowledge card", or any request involving external knowledge ingestion into knowledge/ or experience/ directories.
---

# Knowledge Import

Import business knowledge from various sources (Markdown, text, Confluence, Jira, URL, PDF) into standardized knowledge cards.

## Workflow

0.  **加载上下文 / Load Context**:
    *   读取 `_system/context-map.yaml` 的预算和映射规则。
    *   读取 `_system/tag-taxonomy.yaml` 获取可用的标签分类。
    *   Read `_system/context-map.yaml` for budget and mapping rules. Read `_system/tag-taxonomy.yaml` for available tag categories.

1.  **识别输入源 / Identify Input Source**:
    *   **Markdown/文本 / Markdown/Text**: 直接读取文件内容。Read file content directly.
    *   **URL/网页 / URL/Web**: 用 WebFetch 抓取并转 markdown。Use WebFetch to retrieve and convert to markdown.
    *   **Jira ticket**: 调用 `scripts/jira-cli.sh pull-prd` 获取。Use `scripts/jira-cli.sh pull-prd` to fetch.
    *   **文件路径 / File path**: 读取本地文件。Read local file.
    *   **用户粘贴文本 / Pasted text**: 直接使用。Use directly.
    *   如果输入源不明确，询问用户。If source is ambiguous, ask the user.

2.  **内容抽取与结构化 / Extract & Structure**:
    *   提取标题、关键概念、业务规则、术语表。Extract title, key concepts, business rules, glossary.
    *   生成摘要（Overview 章节）。Generate summary (Overview section).
    *   识别可测试点（Testing Considerations 章节）。Identify testable points (Testing Considerations section).

3.  **脱敏处理 / Sanitization**:
    *   检查 `_system/config.yaml` 的 `import.sanitize_on_import` 配置。Check `import.sanitize_on_import` in `_system/config.yaml`.
    *   如果为 `true`，对源内容运行 `scripts/sanitize.sh`。If `true`, run `scripts/sanitize.sh` on source content.

4.  **分类与打标签 / Classify & Tag**:
    *   判断 category：`domain`（业务知识）还是 `tech`（技术知识）。Determine category: `domain` (business) or `tech` (technical).
    *   从 `_system/tag-taxonomy.yaml` 选取合适的 tags。Select appropriate tags from `_system/tag-taxonomy.yaml`:
        *   `domain/{value}` — 业务领域。Business domain.
        *   `knowledge/{type}` — 知识类型（tech, domain, methodology）。Knowledge type.
        *   `module/{value}` — 关联模块。Related module.
    *   确定目标路径。Determine target path:
        *   业务知识 → `knowledge/domain/`。Business knowledge → `knowledge/domain/`.
        *   技术知识 → `knowledge/tech/`。Technical knowledge → `knowledge/tech/`.

5.  **去重检测 / Duplicate Detection**:
    *   搜索 `knowledge/` 下是否已有相同主题的文件（按标题和 tags 匹配）。Search `knowledge/` for existing files with the same topic (match by title and tags).
    *   如有重复，询问用户。If duplicates found, ask the user:
        *   跳过 / Skip
        *   覆盖 / Overwrite
        *   合并 / Merge
        *   创建新版本 / Create new version

6.  **生成知识卡片 / Generate Knowledge Card**:
    *   使用模板 `commons/templates/knowledge-card.md` 生成 markdown 文件。Use template `commons/templates/knowledge-card.md` to generate markdown file.
    *   填充 frontmatter 和 body 内容。Populate frontmatter and body content.
    *   自动添加 `[[wikilinks]]` 关联相关用例和知识。Auto-add `[[wikilinks]]` linking related cases and knowledge.
    *   写入目标路径。Write to target path.

7.  **导入汇总 / Import Summary**:
    *   输出导入结果。Output import results:
        *   文件路径 / File path
        *   分配的标签 / Assigned tags
        *   关联的用例 / Related cases
        *   审核状态 / Review status

## Knowledge Card Template

引用模板 / Reference template:

```yaml
template: "commons/templates/knowledge-card.md"
```

## Metadata Injection

*   Set `source` based on input type: `markdown`, `confluence`, `jira`, `url`, `manual`.
*   Set `review: pending`.
*   Set `author` to the current agent name.
*   Set `created` and `updated` to today's date.
*   Assign structured tags from `_system/tag-taxonomy.yaml`:
    *   `domain/{value}` — infer from content or prompt user.
    *   `knowledge/{type}` — infer from content (tech, domain, methodology, postmortem, benchmark).
    *   `module/{value}` — match related module if applicable.

## Example Output

### Import Summary
```markdown
## Knowledge Import Summary
- **Source**: `https://confluence.example.com/display/AD/RPP+Spec`
- **Type**: domain
- **Title**: RPP 广告展示规则
- **Path**: `knowledge/domain/rpp-impression-rules.md`
- **Tags**: `domain/ad-rpp`, `knowledge/domain`, `module/RPP`
- **Related Cases**: [[TC-RPP-001]], [[TC-RPP-003]]
- **Status**: `pending` review
```
