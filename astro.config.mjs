import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// 公開先は GitHub Pages（プロジェクトページ）。
//   site … オーナーのPagesドメイン
//   base … リポジトリ名。公開URLは site + base になる
// 独自ドメインに移す場合は site をそのドメインにし、base を削除する。
// 変更したら src/pages/index.astro の SITE_URL と public/robots.txt も合わせること。
export default defineConfig({
  site: 'https://fkdkazu-commits.github.io',
  base: '/ai-automation-lp',
  output: 'static',
  trailingSlash: 'never',
  build: { format: 'directory', inlineStylesheets: 'auto' },
  // /demo/ 配下はポートフォリオ用の架空サービスLP。本サイトのSEOに混ざらないよう
  // サイトマップから除外する（各ページ側にも noindex を入れてある）。
  integrations: [sitemap({ filter: (page) => !page.includes('/demo/') })],
});
