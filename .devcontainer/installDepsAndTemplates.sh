#!/bin/bash
# Install dependencies and template files

# Install dependencies
# --------------------

export DEBIAN_FRONTEND=noninteractive
apt-get update 
apt-get install -y $(cat .devcontainer/dependencies.txt) 


# Set up Python virtual environment
# ---------------------------------

python3 -m venv /lecturetemplate/venv
source /lecturetemplate/venv/bin/activate
/lecturetemplate/venv/bin/pip3 install imageio[ffmpeg] PyPDF2 moviepy natsort pathlib gtts

# Install resources (bibliography)
# --------------------------------

rm -rf bib
git clone https://github.com/dmflickinger/RBE550resources.git bib
ln -s ${PWD}/bib /bib

# Install assignments template
# ----------------------------

mkdir -p $(kpsewhich -var-value=TEXMFLOCAL)/tex/latex/RBElecture/fig
cp -f template/RBElecture.cls $(kpsewhich -var-value=TEXMFLOCAL)/tex/latex/RBElecture/
cp -f template/fig/*.png $(kpsewhich -var-value=TEXMFLOCAL)/tex/latex/RBElecture/fig/
cp -f template/fig/*.pdf $(kpsewhich -var-value=TEXMFLOCAL)/tex/latex/RBElecture/fig/


# Register the RBE assignment class with texlive
# ----------------------------------------------

tlmgr conf texmf TEXMFLOCAL $(kpsewhich -var-value=TEXMFLOCAL)
mktexlsr $(kpsewhich -var-value=TEXMFLOCAL)


# Install the video encoding script
# ---------------------------------

cp -f scripts/encodeVideo.py /usr/local/bin/
cp -f scripts/buildLectureVideo.sh /usr/local/bin/
