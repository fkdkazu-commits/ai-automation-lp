# AI業務自動化支援 LP（Astro版）

既存の [ai-consulting-lp](https://fkdkazu-commits.github.io/ai-consulting-lp/)（GitHub Pages / 素のHTML）をベースに、
`pro-lp-builder` スキルのプロ品質テンプレートで作り直したワンページLPです。

- 公開URL: **https://fkdkazu-commits.github.io/ai-automation-lp/**
- 技術構成: **Astro 5（static出力） + GitHub Pages**（`main` への push で GitHub Actions が自動デプロイ）
- フォント: Noto Sans JP（Google Fonts / CDN）
- 配色: **テラコッタ（暖色・`--accent:#d4622a`）** — pro-lp-builder テンプレート既定のトーン

> 配色を変えたい場合は `src/pages/index.astro` の `:root` にある
> `--accent` / `--accent2` / `--accent-light` / `--accent-soft` / `--claude` の5変数を差し替えれば全面に反映されます。
> （ネイビー系にするなら `#d4622a → #2b6cb0` / `#b8451a → #1a4f8a` / `#e8844e → #63b3ed` / `#fef2e9 → #ebf8ff` / `#d77b54 → #63b3ed`）

## ディレクトリ

```
pro-lp-builder/
├── .github/workflows/
│   └── deploy.yml          # main への push で GitHub Pages へ自動デプロイ
├── astro.config.mjs        # site（Pagesドメイン）・base（リポジトリ名）・sitemap
├── vercel.json             # ★現在は未使用（Vercelへ移す場合のセキュリティヘッダ設定）
├── package.json
├── public/
│   ├── ogp.png             # OGP画像 1200×630（scripts/ogp.html から生成）
│   ├── favicon-32.png / icon-192.png / apple-touch-icon.png
│   ├── robots.txt / site.webmanifest
│   ├── images/             # profile.png / marketing-dashboard-sample.png
│   ├── news/               # お知らせカードのバナー画像
│   └── demo/               # デモページ用の製品画面キャプチャ（mock-*.png）
├── scripts/
│   ├── ogp.html            # OGP画像の版下（HTML）
│   ├── icon.html           # ファビコンの版下（HTML）
│   ├── mock.css            # 製品画面モックの共通スタイル
│   └── mock-*.html         # 製品画面モックの版下（map / trend / area / report）
└── src/
    ├── styles/
    │   ├── lp-base.css     # 暖色系デザインシステム（pro-lp-builder テンプレート由来）
    │   └── saas-base.css   # 白×紺×緑のBtoB SaaS向けデザインシステム（独立）
    └── pages/
        ├── index.astro                 # 本番LP（AI業務自動化支援）← lp-base.css
        └── demo/jinryu-scope.astro     # デザインサンプル（架空サービス・noindex）← saas-base.css
```

### デザインシステムが2本ある理由

`lp-base.css` はテンプレート既定の**暖色（`#d4622a`）＝ Claude のブランドカラー**を土台にしており、
変数名にも `--claude` が残っています。Claude Code の支援サービスを扱う本番LPではそれで問題ありませんが、
**それ以外のブランドに流用すると「Claude っぽさ」がそのまま出ます**。

そのため、デモページには別系統の `saas-base.css` を用意しました。
テンプレートの**セクション構成・レスポンシブ設計・コンポーネント分割の考え方は踏襲**しつつ、意匠は独立させています。

| | lp-base.css | saas-base.css |
|---|---|---|
| アクセント | テラコッタ `#d4622a` | グリーン `#0e9f6e` |
| 文字色 | ほぼ黒 `#0b0b0c` | 紺 `#102a43` |
| ダーク帯 | 焦げ茶 `#1a1714` | 紺 `#0b2138` |
| ボタン | pill型（`radius:100px`）＋グラデ＋発光シャドウ | 角丸8px・単色・影は最小限 |
| 見出し | weight 900・字間タイト | weight 800 |
| 角丸 | 14〜20px | 10〜14px |
| `--claude` 変数 | あり | **なし**（`--accent-on-dark` に置換） |

新しいブランドのLPを作るときは、**どちらかを複製して `:root` を差し替える**のが最短です。

### CSSの置き場所

カラートークン・タイポ・ボタン・カード・レスポンシブなど**共通の指定はデザインシステム側のCSS**、
**ページ固有の指定は各 `.astro` の `<style>`** に書きます。

> Astro はスコープ付きスタイルに `[data-astro-cid-*]` を足すため、ページ側の `<style>` は
> 共通CSSより詳細度が1段高くなり、記述順に関係なく必ず勝ちます。
> （逆に、同じファイル内の `<style>` 同士は出力順が直感と一致しないことがあるため、
> 共通指定を上書きしたいときは必ず共通CSS側かページ側かを分けること）

## ローカル開発

```bash
npm install
npm run dev        # → http://localhost:4321/
npm run build      # dist/ に静的出力
npm run preview
```

ポート **4321** は `claude code/PORTS.md` に登録済みです。

## 画像の作り直し方

OGP画像・ファビコンは HTML の版下を Edge のヘッドレスでスクリーンショットして生成しています。
文言や配色を変えたいときは `scripts/ogp.html` を編集して以下を実行してください。

```bash
EDGE="/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"
"$EDGE" --headless --disable-gpu --no-sandbox --hide-scrollbars \
  --window-size=1200,630 \
  --screenshot="<絶対パス>\public\ogp.png" \
  "file:///<絶対パス>/scripts/ogp.html"
```

ファビコンは `scripts/icon.html` を同じ方法で 32 / 180 / 192 のウィンドウサイズで撮影します。

## 公開先とURLの仕組み

GitHub Pages の**プロジェクトページ**として公開しているため、URLは `オーナーのPagesドメイン + リポジトリ名` になります。

| ファイル | 値 |
|---|---|
| `astro.config.mjs` | `site: 'https://fkdkazu-commits.github.io'` / `base: '/ai-automation-lp'` |
| `src/pages/index.astro` | `SITE_URL = 'https://fkdkazu-commits.github.io/ai-automation-lp'`（canonical / OGP / JSON-LD で使用） |
| `public/robots.txt` | `Sitemap:` の行 |
| `public/site.webmanifest` | `start_url` とアイコン3つのパス（**静的ファイルなので base を直書き**） |

### `${BASE}` を必ず付ける

`public/` 配下の画像・アイコンは **Astro が自動でリライトしません**。サブパス公開ではパスが壊れるため、
各ページの frontmatter で

```js
const BASE = import.meta.env.BASE_URL.replace(/\/$/, '');
```

を定義し、`src={`${BASE}/images/profile.png`}` の形で参照しています。**新しい画像を足すときも同じ形にすること。**

### 独自ドメインに移す場合

1. `astro.config.mjs` の `site` をそのドメインにし、**`base` の行を削除**（`BASE` は空文字になり、コードはそのまま動きます）
2. `src/pages/index.astro` の `SITE_URL`、`public/robots.txt`、`public/site.webmanifest` を新ドメインに
3. リポジトリに `public/CNAME`（ドメイン名1行）を追加し、DNSに CNAME レコードを設定

### Vercel に移す場合

`vercel.json` にセキュリティヘッダ一式が入っているので、そのまま使えます。
その際は各ページの `<meta http-equiv="Content-Security-Policy">` と `<meta name="referrer">` を削除してください
（ヘッダ側と二重になるため）。

> ただし **Vercel の無料 Hobby プランは非商用向け**とされています。集客用LPは商用に該当する可能性が高いため、
> 移行する場合は Pro プランの要否を確認してください。

## GitHub Pages の制約（把握しておくこと）

Pages は**カスタムHTTPヘッダを設定できません**。そのため `vercel.json` の設定のうち以下が効きません。

| 設定 | 現状の対応 |
|---|---|
| CSP | 各ページの `<meta http-equiv="Content-Security-Policy">` で代替（`frame-ancestors` は meta では無効） |
| Referrer-Policy | `<meta name="referrer">` で代替 |
| **X-Frame-Options / Permissions-Policy / COOP / CORP** | **代替手段なし**（クリックジャッキング対策は未適用） |
| HSTS | `github.io` は HSTS preload 済みのため実質カバーされる |
| 画像の長期キャッシュ（immutable 1年） | 不可。Pages 既定の10分 |
| リダイレクト（`/index.html` → `/` 等） | 不可 |

フォーム送信やログインを持たない静的LPのため実害は限定的ですが、
ヘッダが必要になったら Vercel か Cloudflare Pages（`_headers` でヘッダ設定可・無料で商用可）への移行を検討してください。

## 元サイトからの変更点（意図的なもの）

- **配色をトークン化**：`:root` のアクセント4変数を変えるだけで全面のトーンを変更できます。
- **FAQの納期・サポート回答を現行サービスに合わせて修正**：元サイトは「ベーシック / スタンダード / プレミアム」という
  旧プラン名で回答していましたが、本文のサービス構成（スポット / 業務委託 / DXパック / 家庭教師）と食い違うため、
  現行の4サービスに沿った表現へ書き換えています。
- **顧客ロゴ・顧客の声・講演実績のセクションは不採用**：掲載できる素材がないため、テンプレートから削除しました。
- **活用事例カードに削減率の数値を入れていません**：元サイトに根拠数値がないため、カテゴリ表示のみにしています。
- **詳細ページへのリンクは既存のGitHub Pagesを参照**：本LPはワンページ構成のため、
  サービス詳細・実績詳細・お問合せフォームは既存サイトの各ページに遷移します。

## デザインサンプル（/demo/jinryu-scope）

人流データ分析SaaSのLPを想定した**架空サービスのデザインサンプル**です。制作事例・ポートフォリオとして
使うことを目的にしており、実案件ではありません。

- **社名・サービス名・料金・実績・事例・連絡先はすべて架空**（「人流スコープ」「株式会社ジオリンクス」）
- 構成の参考にした実在サービスの**商標・文言・画像は一切使用していません**
- ページ最上部とフッターの2か所に、架空である旨の告知を常時表示
- 本サイトのSEOに混ざらないよう **`noindex,nofollow` ＋ サイトマップから除外**（`astro.config.mjs` の `filter`）
- 本番LP（`/`）からはリンクしていません。URLを直接共有して見せる想定です

### 「生成物っぽさ」を消すために意図的にやっていること

初版は、全セクションが `英語ラベル → h2 → 説明1文 → 均等なカードグリッド` の繰り返しになり、
一目で機械的に作ったと分かる状態でした。以下を守ることで作り直しています。

| 項目 | 初版 | 現在 |
|---|---|---|
| 英語ラベル（sec-label） | 11回 | 2回 |
| 均等なカードグリッド | 9個 | 0個 |
| 製品画面などの画像 | 0枚 | 5枚 |
| 24×24の線画アイコン | 13個 | 7個 |

- **同じ型を繰り返さない**。機能紹介は左右交互（`.zig`）、料金は比較表（`.ptable`）、
  対応業界は1本の帯（`.chips-band`）、事例は1件だけ大きく（`.case-feat`）、サポートは番号付きリスト。
- **枠のないブロックを混ぜる**。課題提起（`.stmt`）はカードを使わず、区切り線だけで組んでいます。
- **項目数を揃えすぎない**。文の長さと語尾もあえて不揃いにしています。
- **画面キャプチャを主役にする**。これが一番効きます（下記）。

### 配色の設計（1色に頼らない）

緑1色だけで組むと、色が「装飾」にしかならず平坦に見えます。役割を分けて2系統持たせています。

| 系統 | 変数 | 使いどころ |
|---|---|---|
| **アクション色** | `--accent`（緑） | CTA・申し込み導線。**ここだけは1色に固定**し、他で使わない |
| **カテゴリ色** | `--c-blue` `--c-purple` `--c-amber` `--c-coral` `--c-teal` | 分析の段階・業種・サポートの層など「種類の違い」 |

カテゴリ色は彩度と明度を揃えてあるので、隣り合っても濁りません。各色に `-soft`（淡背景用）と
`-on-dark`（ダーク背景用）を用意しています。

割り当ての例：

- 機能紹介の4段階 → 青／緑／紫／アンバー。**ラベル・見出しの縦罫・チェック印・対応する画面キャプチャまで同じ色で揃える**
- 業種チップ7つ、課題提起の3論点、サポートの5段階、導入フローの5ステップ → それぞれ色分け
- 料金表は標準プラン＝緑、Lite＝青で役割を区別

> チェック印は `mask` で描いているので、親要素に `--ck-color` を指定するだけで色が変わります。

### 製品画面モックの作り方

`scripts/mock-*.html` が版下です。実在プロダクトのスクリーンショットは使わず、
分析SaaSのUIをHTML/CSSで組んでキャプチャしています。

```bash
EDGE="/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"
"$EDGE" --headless --disable-gpu --no-sandbox --hide-scrollbars \
  --user-data-dir="<毎回別のパス>" --window-size=1200,760 \
  --screenshot="<絶対パス>\public\demo\mock-map.png" \
  "file:///<絶対パス>/scripts/mock-map.html"
```

> Edge のヘッドレスは**初回実行が無言で失敗することがあります**。同じコマンドをもう一度実行すれば通ります。
- **Claude 由来の意匠・記述は排除済み**。ビルド後の HTML / CSS に `claude` の文字列は0件、
  暖色（`#d4622a` 系）も0件であることを確認しています：
  ```bash
  grep -ic "claude" dist/demo/jinryu-scope/index.html dist/_astro/jinryu-scope*.css   # → 0
  ```

`/demo/` 配下にページを増やす場合も、同じく `noindex` を入れれば自動でサイトマップから外れます。

## 残タスク

- [x] 公開先の決定（GitHub Pages）とURL確定
- [x] GitHub Actions による自動デプロイの設定
- [ ] お問合せフォームを本LP内に持たせるかの判断（現状は既存 `contact.html` へ遷移）
- [ ] アクセス解析の要否（元サイトはMicrosoft Clarityを導入。**入れる場合は各ページの CSP meta に許可を追加**）
- [ ] 独自ドメインの取得可否（取得する場合は上記「独自ドメインに移す場合」の3手順）
