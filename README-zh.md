# TableGPT Ipython Kernel

**其他语言阅读: [English](README.md).**

用于为TableGPT项目生成代码执行环境的Docker镜像。基于`elyra/kernel-py`镜像，安装了额外的数据分析包和中文字体支持。

## 快速开始

```bash
docker pull tablegpt/ipy-kernel:latest
```

## 启动脚本

建议在启动脚本中放置一些辅助函数或配置。将你的启动脚本放入`~/.ipython/profile_default/startup/`目录中以生效。

注意：`~/.ipython`目录必须对启动内核的进程可写，否则会出现警告信息：`UserWarning: IPython dir '/home/jovyan/.ipython' is not a writable location, using a temp directory.` 启动脚本将无法生效。

官方文档在`~/.ipython/profile_default/startup/README`：

> This is the IPython startup directory
>
> .py and .ipy files in this directory will be run *prior* to any code or files specified
> via the exec_lines or exec_files configurables whenever you load this profile.
>
> Files will be run in lexicographical order, so you can control the execution order of files
> with a prefix, e.g.::
>
>     00-first.py
>     50-middle.py
>     99-last.ipy
