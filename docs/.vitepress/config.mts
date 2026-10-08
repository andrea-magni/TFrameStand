import { defineConfig } from 'vitepress'
import fs from 'node:fs'
import path from 'node:path'

// public address of the site (GitHub Pages): sitemap, canonical URLs, llms.txt
const SITE_URL = 'https://andrea-magni.github.io/TFrameStand/'
const SITE_DESCRIPTION = 'TFrameStand and TFormStand: Delphi FireMonkey (FMX) components to show frames and forms through reusable, animated "stands" — transitions, dialogs, lightboxes, wait screens and responsive layouts.'

// sections of llms.txt, in the order of the sidebar
const LLMS_SECTIONS: [string, string][] = [
  ['Guide', 'guide/'],
  ['Features', 'features/'],
  ['Reference', 'reference/'],
  ['Demos', 'demos/'],
]
const LLMS_EXTRA = ['release-notes.md']

function splitFrontmatter(md: string): { data: Record<string, string>, body: string } {
  const data: Record<string, string> = {}
  const m = md.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n/)
  if (!m) return { data, body: md }
  for (const line of m[1].split(/\r?\n/)) {
    const kv = line.match(/^(\w+):\s*(.*)$/)
    if (kv) data[kv[1]] = kv[2].replace(/^['"]|['"]$/g, '')
  }
  return { data, body: md.slice(m[0].length) }
}

// title (first "# " heading) and description (frontmatter, or the first paragraph as plain text)
function pageSummary(md: string): { title: string, description: string } {
  const { data, body } = splitFrontmatter(md)
  const title = data.title || (body.match(/^#\s+(.+)$/m)?.[1] ?? '').trim()
  let description = data.description || ''
  if (!description) {
    const para = body.split(/\r?\n\s*\r?\n/).map(b => b.trim())
      .find(b => b && !/^(#|```|:::|\||<|-\s|\d+\.\s|!\[|\[\[)/.test(b))
    description = (para ?? '')
      .replace(/!\[[^\]]*\]\([^)]*\)/g, '')
      .replace(/\[([^\]]+)\]\([^)]*\)/g, '$1')
      .replace(/[`*_]/g, '')
      .replace(/\s+/g, ' ')
      .trim()
  }
  if (description.length > 300) description = description.slice(0, 297).replace(/\s+\S*$/, '') + '...'
  return { title, description }
}

function pageUrl(relativePath: string): string {
  return SITE_URL + relativePath.replace(/(^|\/)index\.md$/, '$1').replace(/\.md$/, '')
}

const guideSidebar = [
  {
    text: 'Getting Started',
    items: [
      { text: 'Introduction', link: '/guide/introduction' },
      { text: 'Installation', link: '/guide/installation' },
      { text: 'Your First Stand', link: '/guide/getting-started' },
      { text: 'Core Concepts', link: '/guide/core-concepts' },
      { text: 'Designing Stands', link: '/guide/stands' },
      { text: 'Lifecycle & Ownership', link: '/guide/lifecycle' },
      { text: 'FAQ & Troubleshooting', link: '/guide/faq' },
    ],
  },
  {
    text: 'Features',
    items: [
      { text: 'Animations', link: '/features/animations' },
      { text: 'Common Actions', link: '/features/common-actions' },
      { text: 'Context Injection', link: '/features/injection' },
      { text: 'TFormStand', link: '/features/formstand' },
      { text: 'Responsive Frames', link: '/features/responsive' },
      { text: 'Background Work', link: '/features/background-work' },
      { text: '3D Stands', link: '/features/stand-3d' },
      { text: 'Design-time Editor', link: '/features/component-editor' },
    ],
  },
]

const referenceSidebar = [
  {
    text: 'Reference',
    items: [
      { text: 'TFrameStand / TFormStand', link: '/reference/components' },
      { text: 'TFrameInfo / TFormInfo', link: '/reference/subject-info' },
      { text: 'Attributes', link: '/reference/attributes' },
      { text: 'Events', link: '/reference/events' },
      { text: 'Units & Packages', link: '/reference/units' },
    ],
  },
]

// TFrameStand documentation site configuration
export default defineConfig({
  base: '/TFrameStand/',
  title: 'TFrameStand',
  description: SITE_DESCRIPTION,
  lang: 'en-US',
  lastUpdated: true,
  cleanUrls: true,
  ignoreDeadLinks: false,

  // Internal maintenance docs that should not be part of the published site.
  srcExclude: ['REGEN.md', 'ANALYSIS.md'],

  sitemap: {
    hostname: SITE_URL,
  },

  head: [
    ['link', { rel: 'icon', href: '/TFrameStand/logo.png' }],
    ['meta', { name: 'theme-color', content: '#f44336' }],
    ['meta', { name: 'keywords', content: 'Delphi, Object Pascal, FireMonkey, FMX, TFrame, TForm, TFrameStand, TFormStand, UI, animations, transitions, dialogs, lightbox, responsive, Android, iOS, macOS, Windows' }],
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'og:site_name', content: 'TFrameStand' }],
    ['meta', { property: 'og:image', content: SITE_URL + 'logo.png' }],
    ['meta', { name: 'twitter:card', content: 'summary' }],
    ['link', { rel: 'alternate', type: 'text/plain', title: 'llms.txt', href: SITE_URL + 'llms.txt' }],
  ],

  // pages without a description in the frontmatter: the first paragraph (meta description)
  transformPageData(pageData, { siteConfig }) {
    if (!pageData.frontmatter.description && pageData.relativePath) {
      const file = path.join(siteConfig.srcDir, pageData.relativePath)
      if (fs.existsSync(file)) {
        const { description } = pageSummary(fs.readFileSync(file, 'utf-8'))
        if (description) pageData.description = description
      }
    }
  },

  // canonical URL and Open Graph / Twitter tags of every page
  transformHead({ pageData, title, description }) {
    const url = pageUrl(pageData.relativePath)
    return [
      ['link', { rel: 'canonical', href: url }],
      ['meta', { property: 'og:url', content: url }],
      ['meta', { property: 'og:title', content: title }],
      ['meta', { property: 'og:description', content: description }],
      ['meta', { name: 'twitter:title', content: title }],
      ['meta', { name: 'twitter:description', content: description }],
    ]
  },

  // llms.txt (index of the pages, https://llmstxt.org), llms-full.txt (all the pages in one file)
  // and a plain markdown copy of every page next to its HTML
  buildEnd(siteConfig) {
    const pages = siteConfig.pages.filter(p => LLMS_SECTIONS.some(([, prefix]) => p.startsWith(prefix)) || LLMS_EXTRA.includes(p))
    const read = (p: string) => fs.readFileSync(path.join(siteConfig.srcDir, p), 'utf-8')
    const order = (p: string) => { const i = LLMS_SECTIONS.findIndex(([, prefix]) => p.startsWith(prefix)); return i < 0 ? 99 : i }
    // pages in the order of the sidebar
    const sidebarLinks: string[] = []
    const collect = (items: any[]) => items?.forEach(item => {
      if (item.link) sidebarLinks.push(item.link.replace(/^\//, '').replace(/\/$/, '/index') + '.md')
      if (item.items) collect(item.items)
    })
    Object.values(siteConfig.site.themeConfig.sidebar ?? {}).forEach(groups => collect(groups as any[]))
    const rank = (p: string) => { const i = sidebarLinks.indexOf(p); return i < 0 ? Number.MAX_SAFE_INTEGER : i }
    const header = `# TFrameStand\n\n> ${SITE_DESCRIPTION}\n\n`
      + 'TFrameStand and TFormStand are open source (MPL 2.0) components for Embarcadero Delphi FireMonkey. '
      + 'Source code, releases and demos: https://github.com/andrea-magni/TFrameStand\n'
    let index = header
    let full = header
    const sections = [...LLMS_SECTIONS.map(([name]) => name), 'More']
    for (const [i, name] of sections.entries()) {
      const inSection = pages.filter(p => order(p) === (i < LLMS_SECTIONS.length ? i : 99))
        .sort((a, b) => rank(a) - rank(b) || a.localeCompare(b))
      if (!inSection.length) continue
      index += `\n## ${name}\n\n`
      for (const p of inSection) {
        const md = read(p)
        const { title, description } = pageSummary(md)
        const mdUrl = pageUrl(p).replace(/\/$/, '/index') + '.md'
        index += `- [${title}](${mdUrl})${description ? ': ' + description : ''}\n`
        const body = splitFrontmatter(md).body
        full += `\n\n---\n\nSource: ${pageUrl(p)}\n\n${body.trim()}\n`
        const out = path.join(siteConfig.outDir, p)
        fs.mkdirSync(path.dirname(out), { recursive: true })
        fs.writeFileSync(out, body)
      }
    }
    fs.writeFileSync(path.join(siteConfig.outDir, 'llms.txt'), index)
    fs.writeFileSync(path.join(siteConfig.outDir, 'llms-full.txt'), full)
  },

  themeConfig: {
    logo: '/logo.png',

    nav: [
      { text: 'Guide', link: '/guide/introduction' },
      { text: 'Features', link: '/features/animations' },
      { text: 'Reference', link: '/reference/components' },
      { text: 'Demos', link: '/demos/' },
      { text: 'Release Notes', link: '/release-notes' },
      {
        text: 'Links',
        items: [
          { text: 'GitHub', link: 'https://github.com/andrea-magni/TFrameStand' },
          { text: 'Latest release', link: 'https://github.com/andrea-magni/TFrameStand/releases/latest' },
          { text: 'GetIt package manager', link: 'https://getitnow.embarcadero.com/?q=TFrameStand' },
          { text: 'Blog posts', link: 'https://blog.andreamagni.eu/tag/tframestand/' },
          { text: 'CodeRage X session (video)', link: 'https://www.youtube.com/watch?v=Z6_ZvnCmFCw' },
          { text: "Author's site", link: 'https://www.andreamagni.eu' },
        ],
      },
    ],

    sidebar: {
      '/guide/': guideSidebar,
      '/features/': guideSidebar,
      '/reference/': referenceSidebar,
      '/demos/': [
        {
          text: 'Demos',
          items: [
            { text: 'Overview', link: '/demos/' },
          ],
        },
      ],
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/andrea-magni/TFrameStand' },
    ],

    editLink: {
      pattern: 'https://github.com/andrea-magni/TFrameStand/edit/master/docs/:path',
      text: 'Edit this page on GitHub',
    },

    search: {
      provider: 'local',
    },

    footer: {
      message: 'Released under the Mozilla Public License 2.0.',
      copyright: 'Copyright © 2015-present Andrea Magni',
    },
  },
})
