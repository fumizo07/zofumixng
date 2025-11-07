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
  'use_default_settings: true' \
  '' \
  'server:' \
  '  limiter: false' \
  '  image_proxy: false' \
  '' \
  'ui:' \
  '  default_theme: simple' \
  '  default_locale: ja' \
  '  infinite_scroll: true' \
  '  favicons:' \
  '    resolver: duckduckgo' \
  '' \
  'search:' \
  '  safe_search: 0' \
  '  default_lang: ja' \
  '' \
  'outgoing:' \
  '  request_timeout: 2.5' \
  '' \
  '# 使うエンジンだけ定義（ここに書いたもの“だけ”有効）' \
  'engines:' \
  '  - name: bing' \
  '    engine: bing' \
  '    timeout: 2.0' \
  '  - name: brave' \
  '    engine: brave' \
  '    timeout: 2.0' \
  '  - name: duckduckgo' \
  '    engine: duckduckgo' \
  '    timeout: 2.0' \
  '  - name: google' \
  '    engine: google' \
  '    timeout: 2.0' \
  '  - name: startpage' \
  '    engine: startpage' \
  '    timeout: 2.0' \
  > /etc/searxng/settings.yml
