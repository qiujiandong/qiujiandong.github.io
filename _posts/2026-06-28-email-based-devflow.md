---
title: 基于邮件 Patch 的开发流程
date: 2026-06-28 12:29 +0000
tags:
  - Linux
  - Kernel
  - Email
---

大型开源项目一般都采用 Patch workflows, 记录一下个人配置开发环境的流程。

Linux 内核的开发便是如此, 也最容易通过相关的文档来入门。

## 参考资料

- [The Linux Kernel Documentation](https://www.kernel.org/doc/html/latest/index.html)
- [Learn to use email with git!](https://git-send-email.io/#step-1)
- [Use plain text email](https://useplaintext.email/)

## 概述

整体来说，Patch 以邮件作为载体供社区中的大伙来审阅、讨论。

在 [The Linux Kernel Mailing List (LKML)](https://lore.kernel.org/lkml/)
中列出的就是最新的一些 Patch, 这个网页相当于是一个公共收件箱，每个发出来的 Patch
都会抄送 LKML, 所以负责审阅的人都能从这里拉取到 Patch (可以借助
[b4](https://b4.docs.kernel.org/en/latest/index.html) 来实现很多方便的功能)

在实际开发过程中主要就是三个问题，

1. 如何准备 Patch ？
2. 如何发送 Patch ？
3. 如何回复 Review 的意见？

## 准备 Patch

git 仓库中的 commit 可以用 `git format-patch` 的方式来生成 Patch, 如果直接只指定
commit 就会把指定的 commit（不包括这个commit）的到当前 HEAD 的 commit
都分别生成 Patch.

```bash
git format-patch [commit]
```

更常见的用法是指定 commit 的数量。如果指定了数量 \<n\>，那就是从指定的 commit 往前数 n
个 commit

```bash
git format-patch -n [commit]
```

这里的 `commit` 如果省略，那就是从当前 HEAD 开始往前数 n 个 commit. (包括当前HEAD)
我觉得这一般也是最常用的做法, 有多少个 commit 就指定多少个就好了。

开发过程中为了解决一个问题，可能需要不止一个 commit, 所以发邮件的时候不能单个 Patch
发送，需要组成一个 Patch series 再发送。这个时候会用到 `--cover-letter` 这个选项,
将多个 Patch 组成一个 Patch series, 并且有一个封面，用来总结这些 Patch 的目的。

用 git 发送 Patch series 的时候，实际上还是每个 Patch 一封邮件，并且封面是第一封邮件,
每个邮件都被称为一个 Message, 后面每个 Patch 按照提交的先后顺序依次回复这个封面的邮件.

不同的 Patch 版本，可以在 format-patch 的时候来指定

```bash
git format-patch -v<n>
```

大家对一个 Patch 或者 Patch series 的讨论 Message 会组成一个 Thread。
有一个常见的选项是 `--in-reply-to`，可以用它指定前一个版本的 Message-ID,
然后这个新的 Patch, 就可以追加到原来的 Thread 里。这样可以比较方便追踪历史。
但是这只适用于 Patch 中只有一个 commit 的情况，如果是 Patch series, **不推荐**
用这个选项，因为这会让整个 Thread 变得很复杂。推荐只在封面里加上版本说明，
并附上前面几个版本在LKML上的链接。

## 发送 Patch

这个问题在 [Learn to use email with git!](https://git-send-email.io/#step-2)
中有完整的解答。而且 `git send-email` 也可以完成 `format-patch` 的功能，
直接发送邮件，跳过产生 Patch 的过程，但我看了一下开发过程中一般还是推荐先把
Patch 生成出来，方便检查和存档，然后再发送 Patch。

我用的是 Gmail 邮箱，并且配置的是 OAuth2 认证, 所以还需要额外安装一些东西

- [git-credential-email](https://github.com/AdityaGarg8/git-credential-emailhttps://github.com/AdityaGarg8/git-credential-email)

``` bash
pip install keyring requests keyring.alt
```

其中 keyring.alt 用于给 keyring 提供后端实现。后面就是按照 git-credential-email
仓库中的说明完成配置即可。

```bash
git credential-gmail --set-client
git credential-gmail --authenticate
```

然后再更新一下 git config 的配置就可以用 `git send-email` 来发送邮件了。

## 回复 Review 意见

回复 Review 意见时主要需要注意发送 Plain Text 的邮件。可以参考
[Use plain text email](https://useplaintext.email/)

我一开始使用的 thunderbird, 但是我后来发现还是命令行好用，所以切换到了
[neomutt](https://neomutt.org/) + mbsync + msmtp

- mbsync 用来将 Gmail 邮箱中的邮件同步到本地
- msmtp 用来发送邮件
- neomutt 是一个邮件客户端，用看来查看和回复邮件

相关的配置我也都同步到我的 [dotfile](https://github.com/qiujiandong/dotfiles)
里了。

主要是登陆 Gmail 邮箱时可以设置一个独立的 app 密码 [Sign in with app passwords](https://support.google.com/mail/answer/185833)
然后用 `pass` 来管理。

