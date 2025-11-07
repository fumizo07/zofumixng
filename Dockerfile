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

# ★ 追加：favicons.toml を生成（UIで選択肢を出す）
RUN mkdir -p /etc/searxng && printf '%s\n' \
  '[favicons]' \
  'cfg_schema = 1' \
  '' \
  '[favicons.proxy]' \
  'max_age = 5184000' \
  '' \
  '# 複数の resolver を登録すると UI に選択肢が出る' \
  '[favicons.proxy.resolver_map]' \
  '"duckduckgo" = "searx.favicons.resolvers.duckduckgo"' \
  '"google"    = "searx.favicons.resolvers.google"' \
  > /etc/searxng/favicons.toml


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
  '      - bing videos' \
  '      - google videos' \
  '      - youtube' \
  '      # ニュース' \
  '      - bing news' \
  '      - brave news' \
  '      - google news' \
  '      - yahoo news' \
  '      # 地図' \
  '      - openstreetmap' \
  '      - nominatim' \
  '      - photon' \
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
  '  # 一般' \
  '  - name: bing' \
  '    timeout: 2.0' \
  '    disabled: true' \
  '  - name: brave' \
  '    timeout: 2.0' \
  '  - name: duckduckgo' \
  '    timeout: 2.0' \
  '  - name: google' \
  '    timeout: 2.0' \
  '    disabled: true' \
  '  - name: startpage' \
  '    timeout: 2.0' \
  '  # 画像系の応答改善（軽いタイムアウト上げ）' \
  '  - name: bing images' \
  '    timeout: 3.0' \
  '  - name: brave images' \
  '    timeout: 3.0' \
  '  - name: duckduckgo images' \
  '    timeout: 3.0' \
  '  - name: google images' \
  '    timeout: 3.0' \
  '  - name: startpage images' \
  '    timeout: 3.0' \
  '  # 動画系の応答改善（軽いタイムアウト上げ）' \
  '  - name: bing videos' \
  '    timeout: 2.5' \
  '  - name: google videos' \
  '    timeout: 2.5' \
  '  - name: youtube' \
  '    timeout: 2.5' \
  '  # ニュース系' \
  '  - name: bing news' \
  '    timeout: 2.5' \
  '  - name: brave news' \
  '    timeout: 2.5' \
  '  - name: google news' \
  '    timeout: 2.5' \
  '  - name: yahoo news' \
  '    timeout: 2.5' \
  '  # マップ系' \
  '  - name: openstreetmap' \
  '    timeout: 3.0' \
  '  - name: nominatim' \
  '    timeout: 3.0' \
  '  - name: photon' \
  '    timeout: 3.0' \
  '  # 音楽系' \
  '  - name: bandcamp' \
  '    timeout: 2.5' \
  '  - name: soundcloud' \
  '    timeout: 2.5' \
  '  # ソーシャルメディア系' \
  '  - name: reddit' \
  '    timeout: 2.5' \
  > /etc/searxng/settings.yml

  # --- mobile video layout: float無効化＋縦積み＋時間バッジを右下固定 ---
RUN printf '%s\n' \
  '/* === custom: mobile-only video layout override === */' \
  '@media (max-width: 768px) {' \
  '  /* コンテナは縦積み。既存floatの影響をすべて断つ */' \
  '  body.category-videos .result { display:block; overflow:hidden; }' \
  '  body.category-videos .result::after { content:""; display:block; clear:both; }' \
  '' \
  '  /* よくあるクラス名を網羅してfloat解除＆幅100% */' \
  '  body.category-videos .result .thumbnail,' \
  '  body.category-videos .result .thumb,' \
  '  body.category-videos .result .img,' \
  '  body.category-videos .result .content,' \
  '  body.category-videos .result .result-content,' \
  '  body.category-videos .result .result-header,' \
  '  body.category-videos .result .infobox,' \
  '  body.category-videos .result .engines {' \
  '    float:none !important;' \
  '    width:100% !important;' \
  '    max-width:100% !important;' \
  '  }' \
  '' \
  '  /* サムネは上、本文は下。サムネを相対位置にしてバッジを固定できるようにする */' \
  '  body.category-videos .result .thumbnail,' \
  '  body.category-videos .result .thumb,' \
  '  body.category-videos .result .img {' \
  '    position:relative;' \
  '    margin:0 0 10px 0;' \
  '  }' \
  '  body.category-videos .result .thumbnail img,' \
  '  body.category-videos .result .thumb img,' \
  '  body.category-videos .result .img img {' \
  '    width:100%; height:auto; display:block;' \
  '  }' \
  '' \
  '  /* 動画の長さなど、duration系の要素を右下に絶対配置（クラス名差異に広く対応） */' \
  '  body.category-videos .result .thumbnail .duration,' \
  '  body.category-videos .result .thumb .duration,' \
  '  body.category-videos .result .img .duration,' \
  '  body.category-videos .result [class*="duration"] {' \
  '    position:absolute; right:8px; bottom:8px;' \
  '    float:none !important;' \
  '    display:inline-block;' \
  '    padding:2px 6px;' \
  '    background:rgba(0,0,0,.75); color:#fff;' \
  '    border-radius:4px; font-size:12px; line-height:1;' \
  '    max-width:90%; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;' \
  '  }' \
  '' \
  '  /* 余白の最適化 */' \
  '  body.category-videos .result .result-header { margin:0 0 6px; }' \
  '  body.category-videos .result .content p { margin:0 0 10px; }' \
  '}' \
  >> /usr/local/searxng/searx/static/themes/simple/css/style.css
