FROM fedora

WORKDIR /source

# Install packages (mainly texlive)
# =================================

RUN dnf install -y texlive-adjustbox \
                   texlive-background \
                   texlive-bibtex \
                   texlive-biblatex \
                   texlive-biblatex-ieee \
                   texlive-ccfonts \
                   texlive-changepage \
                   texlive-chktex \
                   texlive-comfortaa \
                   texlive-datetime \
                   texlive-datetime2 \
                   texlive-dot2texi \
                   texlive-draftwatermark \
                   texlive-droid \
                   texlive-electrum \
                   texlive-epigraph \
                   texlive-euro-ce \
                   texlive-fontawesome \
                   texlive-fontawesome5 \
                   texlive-collection-fontsrecommended \
                   texlive-fourier \
                   texlive-ifmtarg \
		   texlive-IEEEtran \
                   texlive-inconsolata \
                   texlive-kpfonts \
                   texlive-lastpage \
                   texlive-listing \
                   texlive-makecmds \
                   texlive-mathdots \
                   texlive-mathspec \
                   texlive-mdframed \
                   texlive-metafont \
                   texlive-minted \
                   texlive-mnsymbol \
                   texlive-multirow \
                   texlive-pdfcrop \
                   texlive-pgfgantt \
                   texlive-pgfopts \
                   texlive-pygmentex \
                   texlive-roboto \
                   texlive-sectsty \
                   texlive-siunitx \
                   texlive-smartdiagram \
                   texlive-sourcecodepro \
                   texlive-subfigmat \
                   texlive-svg \
                   texlive-titlesec \
                   texlive-titling \
                   texlive-tocloft \
                   texlive-todonotes \
                   texlive-wrapfig \
                   texlive-xifthen \
                   texlive-xtab \
                   texlive-xetex \
                   texlive-beamer \
                   texlive-nextpage \
                   texlive-fancybox \
                   texlive-algorithm2e \
                   graphviz \
                   make \
                   ossobuffo-jura-fonts \
                   python3-pygments \
                   python3-pygments-style-solarized \
                   which \
    && dnf clean all


RUN mkdir -p /source \
    && mkdir -p /output \
    && mkdir -p /bib

COPY fig/*.pdf /usr/local/share/LaTeX_templates/RBE550_lecture/fig/

COPY template/RBElecture.cls /usr/share/texlive/texmf-local/tex/latex/RBElecture/
COPY template/fig/*.png /usr/share/texlive/texmf-local/tex/latex/RBElecture/fig/

COPY scripts/build.sh /usr/local/bin/


# Register the RBE lecture class with texlive
RUN tlmgr conf texmf TEXMFHOME /usr/share/texlive/texmf-local \
    && mktexlsr /usr/share/texlive/texmf-local



ENTRYPOINT [ "/usr/local/bin/build.sh" ]

# FIXME: volumes should be defined
#VOLUME [ "/source" "/output" "/bib"]

