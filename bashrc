#! /bin/bash

# 重複したPATHを削除する
function remove_duplicate_path(){
    eval "export PATH=$(perl -e '        #\
        my $e = shift;                   #\
        for(split q/:/, $ENV{"PATH"}){   #\
            if("$_" ne ""){              #\
                $n{$_} or $n{$_} = ++$i; #\
            }                            $\
        }                                #\
        $, = q/:/;                       #\
        %n = reverse %n;                 #\
        print map { $n{$_} }             #\
        sort { $a <=> $b } keys %n       #\
    ')"
}

# .bashrcがあるディレクトリのパスを取得する
# source: http://qiita.com/yudoufu/items/48cb6fb71e5b498b2532
BASHRCDIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

# .bashrc.localの読み込み
if [ -f ${BASHRCDIR}/.bashrc.local ]; then
    source ${BASHRCDIR}/.bashrc.local
fi

# PATHの設定
export PATH=/usr/local/sbin:${PATH}
export PATH=/usr/local/bin:${PATH}
export PATH=/usr/sbin:${PATH}
export PATH=/usr/bin:${PATH}
export PATH=/sbin:${PATH}
export PATH=/bin:${PATH}
export PATH=${BASHRCDIR}/local/bin:${PATH}
remove_duplicate_path

# 参照ライブラリの設定
export LD_LIBRARY_PATH=${BASHRCDIR}/local/lib:${LD_LIBRARY_PATH}

# プロンプト設定
export PS1="[\u@\H \w]\\$ "

# 使用エディタを設定
export EDITOR=${BASHRCDIR}/local/bin/vim

# エイリアス
alias vim='vim -u ${BASHRCDIR}/.vimrc'

# ターミナルの定義
export TERM=xterm-256color

# phpenvの設定
if [ -d ${BASHRCDIR}/.phpenv ]; then
    export PATH=${BASHRCDIR}/.phpenv/bin:${BASHRCDIR}/.phpenv/shims:${PATH}
    eval "$(phpenv init -)"
fi

# rbenvの設定
if [ -d ${BASHRCDIR}/.rbenv ]; then
    export PATH=${BASHRCDIR}/.rbenv/bin:${BASHRCDIR}/.rbenv/shims:${PATH}
    eval "$(rbenv init -)"
fi
