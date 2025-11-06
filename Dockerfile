# 公式の完成済みイメージを使用（ビルド不要）
FROM searxng/searxng:latest

# Renderは$PORTを割り当てるので、それに合わせて待ち受けさせる
ENV SEARXNG_PORT=$PORT
ENV SEARXNG_BIND_ADDRESS=0.0.0.0

# ベースURLやシークレットはRenderの「環境変数」で渡す（ここでは未固定）
# ENV SEARXNG_BASE_URL=
# ENV SEARXNG_SECRET=

# （任意）自前設定に差し替える場合は同名パスへコピー
# COPY settings.yml /etc/searxng/settings.yml

# 公式イメージのデフォルトCMD/ENTRYPOINTのままでOK（uWSGIで起動）
