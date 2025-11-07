# 公式の完成済みイメージを使用（ビルド不要）
# FROM searxng/searxng:latest

# Renderは$PORTを割り当てるので、それに合わせて待ち受けさせる
# ENV SEARXNG_PORT=$PORT
# ENV SEARXNG_BIND_ADDRESS=0.0.0.0

# ベースURLやシークレットはRenderの「環境変数」で渡す（ここでは未固定）
# ENV SEARXNG_BASE_URL=
# ENV SEARXNG_SECRET=

# （任意）自前設定に差し替える場合は同名パスへコピー
# COPY ./settings.yml /etc/searxng/settings.yml

# 公式イメージのデフォルトCMD/ENTRYPOINTのままでOK（uWSGIで起動）

# ここからRender.Dockerfileの中身
# 完成済みの公式イメージを使う
FROM searxng/searxng:latest

# Renderの割り当てポートに追従
ENV SEARXNG_PORT=$PORT
ENV SEARXNG_BIND_ADDRESS=0.0.0.0
# これを明示して「この設定を読め」と強制
ENV SEARXNG_SETTINGS_PATH=/etc/searxng/settings.yml

# settings.yml を“生成”して配置（ここを書き換えれば再デプロイで反映）
RUN mkdir -p /etc/searxng && printf '%s\n' \
  'use_default_settings:' \
  '  # 一般（既定OFFにするのは後段の engines: で上書き）' \
  '  engines:' \
  '    keep_only:' \
  '      - bing' \
  '      - brave' \
  '      - google' \
  '      - duckduckgo' \
  '      - startpage' \
  '      # 画像' \
  '      - bing images' \
  '      - brave images' \
  '      - google images' \
  '      - duckduckgo images' \
  '      - startpage images' \
  '      # 動画' \
  '      - youtube' \
  '      - google videos' \
  '      - bing videos' \
  '      # ニュース' \
  '      - google news' \
  '      - bing news' \
  '      # 地図' \
  '      - openstreetmap' \
  '      # 音楽' \
  '      - bandcamp' \
  '      - soundcloud' \
  '      # SNS（ソーシャルメディア）' \
  '      - reddit' \
  '' \
  'categories_as_tabs:' \
  '  general:' \
  '  images:' \
  '  videos:' \
  '  news:' \
  '  map:' \
  '  music:' \
  '  social media:' \
  '' \
  'server:' \
  '  limiter: false' \
  '  image_proxy: false' \
  '' \
  'ui:' \
  '  default_theme: simple' \
  '  default_locale: ja' \
  '  infinite_scroll: true' \
  '' \
  'search:' \
  '  # ① ファビコン：既定 DuckDuckGo（UIでGoogleにも切替可）' \
  '  favicon_resolver: "duckduckgo"' \
  '  # ② 自動補完：既定 DuckDuckGo（UIでBing/Brave/Google等に切替可）' \
  '  autocomplete: "duckduckgo"' \
  '  safe_search: 0' \
  '  default_lang: ja' \
  '' \
  'outgoing:' \
  '  request_timeout: 2.5' \
  '' \
  '# 使うエンジンだけ定義（ここに書いたもの“だけ”有効）' \
  'engines:' \
  '  - name: bing' \
  '    timeout: 2.0' \
  '    disabled: true' \
  '  - name: brave' \
  '    timeout: 2.0' \
  '  - name: google' \
  '    timeout: 2.0' \
  '    disabled: true' \
  '  - name: duckduckgo' \
  '    timeout: 2.0' \
  '  - name: startpage' \
  '    timeout: 2.0' \
  '  - name: duckduckgo images' \
  '    timeout: 2.0' \
  '  - name: google images' \
  '    timeout: 2.0' \
  '  - name: bing images' \
  '    timeout: 2.0' \
  '  - name: youtube' \
  '    timeout: 2.5' \
  '  - name: google news' \
  '    timeout: 2.5' \
  '  - name: bing news' \
  '    timeout: 2.5' \
  '  - name: openstreetmap' \
  '    timeout: 2.5' \
  '  - name: bandcamp' \
  '    timeout: 2.5' \
  '  - name: soundcloud' \
  '    timeout: 2.5' \
  '  - name: reddit' \
  '    timeout: 2.5' \
  > /etc/searxng/settings.yml
