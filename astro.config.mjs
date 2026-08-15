import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// 公開URL。独自ドメイン確定後は src/pages/index.astro の SITE_URL と
// vercel.json の Link ヘッダも同じ値に揃えること。
export default defineConfig({
  site: 'https://ai-automation-lp.vercel.app',
  output: 'static',
  trailingSlash: 'never',
  build: { format: 'directory', inlineStylesheets: 'auto' },
  // /demo/ 配下はポートフォリオ用の架空サービスLP。本サイトのSEOに混ざらないよう
  // サイトマップから除外する（各ページ側にも noindex を入れてある）。
  integrations: [sitemap({ filter: (page) => !page.includes('/demo/') })],
});
