#!/bin/bash


# Install assignments template
# ----------------------------

mkdir -p $(kpsewhich -var-value=TEXMFLOCAL)/tex/latex/RBElecture/fig
cp -f template/RBElecture.cls $(kpsewhich -var-value=TEXMFLOCAL)/tex/latex/RBElecture/
cp -f template/fig/*.png $(kpsewhich -var-value=TEXMFLOCAL)/tex/latex/RBElecture/fig/


# Register the RBE assignment class with texlive
# ----------------------------------------------

tlmgr conf texmf TEXMFLOCAL $(kpsewhich -var-value=TEXMFLOCAL)
mktexlsr $(kpsewhich -var-value=TEXMFLOCAL)
