FROM ubuntu:latest


WORKDIR /source


RUN mkdir -p /source \
    && mkdir -p /output \
    && mkdir -p /bib

COPY .devcontainer/dependencies.txt /tmp/
COPY .devcontainer/python_dependencies.txt /tmp/

# Install dependencies
# --------------------
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y $(cat /tmp/dependencies.txt) \
    && apt-get clean all


# Set up Python virtual environment
# ---------------------------------

RUN python3 -m venv /lecturetemplate/venv \
    && . /lecturetemplate/venv/bin/activate \
    && /lecturetemplate/venv/bin/pip3 install -r /tmp/python_dependencies.txt

# Install resources (bibliography)
# --------------------------------

RUN rm -rf /bib \
    && git clone https://github.com/dmflickinger/RBE550resources.git bib


# Install assignments template
# ----------------------------

COPY template/RBElecture.cls /tmp/template/
COPY template/fig/*.png /tmp/template/fig/

RUN mkdir -p $(kpsewhich -var-value=TEXMFLOCAL)/tex/latex/RBElecture/fig \
    && cp -f /tmp/template/RBElecture.cls $(kpsewhich -var-value=TEXMFLOCAL)/tex/latex/RBElecture/ \
    && cp -f /tmp/template/fig/*.png $(kpsewhich -var-value=TEXMFLOCAL)/tex/latex/RBElecture/fig/


# Register the RBE assignment class with texlive
# ----------------------------------------------

RUN tlmgr conf texmf TEXMFLOCAL $(kpsewhich -var-value=TEXMFLOCAL) \
    && mktexlsr $(kpsewhich -var-value=TEXMFLOCAL)


# Install the video encoding script
# ---------------------------------

COPY scripts/encodeVideo.py /usr/local/bin/
COPY scripts/buildLectureVideo.sh /usr/local/bin/
COPY scripts/build.sh /usr/local/bin/

ENTRYPOINT [ "/usr/local/bin/build.sh" ]

# FIXME: volumes should be defined
#VOLUME [ "/source" "/output" "/bib"]

# NOTE: podman run --rm -v .:/source -v ./output:/output -v ./bib:/bib rbe550-lecture-template
