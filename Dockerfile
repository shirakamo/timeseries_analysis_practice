FROM python:3.12

# aptパッケージインストールとロケール設定
RUN apt-get update && \
  apt-get -y upgrade && \
  apt-get -y install sudo locales git&& \
  localedef -f UTF-8 -i ja_JP ja_JP.UTF_8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9

# キャッシュクリア
RUN apt-get clean

# pipアップデート
RUN python -m pip install --upgrade pip \
  && python -m pip install --upgrade setuptools
# pythonライブラリインストール
COPY requirements.txt /tmp/
RUN python -m pip install -r /tmp/requirements.txt

# ユーザを作成してsudoグループに加える
ARG DOCKER_UID
ARG DOCKER_USER
ARG DOCKER_PASSWORD
RUN useradd -m --uid ${DOCKER_UID} --groups sudo ${DOCKER_USER} \
  && echo ${DOCKER_USER}:${DOCKER_PASSWORD} | chpasswd

# 作成したユーザーに切り替える
USER ${DOCKER_USER}
ENV HOME /home/${DOCKER_USER}

# ワーキングディレクトリ変更
WORKDIR /home/${DOCKER_USER}
