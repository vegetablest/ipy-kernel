FROM python:3.12-slim

USER root

# install chinese font
RUN apt-get update \
  && apt-get install -y --no-install-recommends fonts-noto-cjk \ 
  && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# install dependencies and clean up
RUN python -m pip install --no-cache-dir -r requirements.txt \
  && pip install -U --no-cache-dir ipykernel pycryptodomex==3.19.0 \
  && rm -rf /root/.cache/*

# set chinese font for matplotlib
RUN MATPLOTLIBRC=$(python -c "import matplotlib; print(matplotlib.matplotlib_fname())") && \
    sed -i 's/\s*font.family\s*:\s*sans-serif\s*/font.family: Noto Serif CJK SC, sans-serif/' $MATPLOTLIBRC

COPY bootstrap-kernel.sh /usr/local/bin/
COPY kernel-launchers /usr/local/bin/kernel-launchers

# add user and configure permissions
RUN adduser --system --group --home /home/tablegpt tablegpt \
  && chown -R tablegpt:tablegpt /usr/local/bin/bootstrap-kernel.sh /usr/local/bin/kernel-launchers \
  && chmod 0755 /usr/local/bin/bootstrap-kernel.sh 

USER tablegpt:tablegpt

# create ipython profile directory
RUN mkdir -p /home/tablegpt/.ipython/profile_default/startup/

ENV KERNEL_LANGUAGE=python

CMD ["/usr/local/bin/bootstrap-kernel.sh"]
