# 完成済みの公式イメージを使う
FROM searxng/searxng:latest

# Renderの割り当てポートに追従
ENV SEARXNG_PORT=$PORT
ENV SEARXNG_BIND_ADDRESS=0.0.0.0

# settings.yml をコンテナ内に生成（必要に応じて編集可）
RUN mkdir -p /etc/searxng && printf '%s\n' \
  'use_default_settings: true' \
  'server:' \
  '  limiter: false' \
  '  image_proxy: false' \
  'ui:' \
  '  default_theme: simple' \
  '  default_locale: ja' \
  '  infinite_scroll: true' \
  '  favicons:' \
  '    resolver: duckduckgo' \
  'search:' \
  '  safe_search: 0' \
  '  default_lang: ja' \
  '  request_timeout: 2.5' \
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
