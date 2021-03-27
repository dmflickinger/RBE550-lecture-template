% Template for RBE lectures
% Daniel Montrallo Flickinger, PhD
% 2021

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{RBElecture}[WPI RBE course lecture class]


% Based on Beamer
\LoadClass[aspectratio=169]{beamer}



% Parameters
% ----------



\RequirePackage{pgfkeys}

\pgfkeys{
/myRBEtitleframe/.is family, /myRBEtitleframe,
default/.style =
  {title = Lecture, author = Unknown Author, courseTitle = RBE-000: Unknown Course, lectureNumber = 0},
title/.estore in = \myRBEtitleframeTitle,
author/.estore in = \myRBEtitleframeAuthor,
courseTitle/.estore in = \myRBEtitleframeCourseTitle,
lectureNumber/.estore in = \myRBEtitleframeLectureNumber,
}

% Required Packages
% -----------------


\RequirePackage{listings}

\RequirePackage[utf8]{inputenc}

% \RequirePackage{palatino}
\RequirePackage[T1]{fontenc}

\RequirePackage{fontawesome}

\RequirePackage{fontspec}
\setsansfont{Jura}
% NOTE: Jura is a stand-in for Eurostile



\RequirePackage{lipsum}

\RequirePackage{epigraph}
\RequirePackage{xcolor}

\RequirePackage{tabularx}



\RequirePackage{babel}
\selectlanguage{English}
% or whatever




\RequirePackage[en-US]{datetime2}
\DTMlangsetup{showdayofmonth=false}

\RequirePackage{ifthen}



% \RequirePackage{helvet}
% \RequirePackage{sourcecodepro}
% \RequirePackage{sourceserifpro}
\RequirePackage{fourier}
% \RequirePackage{ccfonts}

% Or whatever. Note that the encoding and the font should match. If T1
% does not look nice, try deleting the line with the fontenc.


\RequirePackage{caption}
\captionsetup[figure]{labelformat=empty}


% \RequirePackage{ graphics,array,ifthen }
\RequirePackage{ graphicx,array,ifthen }

\RequirePackage{ fancybox }
% \RequirePackage{ picins }


\RequirePackage{hyperref}

% Colors, flowcharts
\RequirePackage{color,colortbl}

\RequirePackage{tikz}
\usetikzlibrary{shapes,arrows}

\RequirePackage{smartdiagram}
\RequirePackage[linesnumbered,lined,boxed,commentsnumbered]{algorithm2e}




% FIXME: breaks a bunch of shit:
% \RequirePackage[sorting=none,style=numeric,doi=true]{biblatex}



% Define colors
% -------------


\definecolor{WPIgray}{RGB}{109,109,109}
\definecolor{WPIcrimson}{RGB}{171,25,45}
\definecolor{WPIgrayCrimson}{RGB}{103,15,27}
\definecolor{SikBlue}{RGB}{34,53,102}
\definecolor{brightOranage}{RGB}{202,67,0}



% Set up Beamer
% -------------


% Get rid of ugly navigation buttons
\setbeamertemplate{navigation symbols}{}


\setbeamertemplate{caption}{\tiny\insertcaption}
\setbeamertemplate{caption label separator}{}

\mode<presentation>
{
  \usetheme{Marburg}
  \usecolortheme[RGB={171,25,45}]{structure}
  \setbeamercolor{alerted text}{fg=WPIcrimson}
  \setbeamercovered{transparent}
  % or whatever (possibly just delete it)
}



\setbeamertemplate{sidebar canvas %
right}[horizontal shading][right=WPIgrayCrimson,left=WPIcrimson]


\setbeamerfont{title}{family=\sffamily\selectfont, shape=\normalfont, series=\bfseries}
\setbeamerfont{frametitle}{family=\sffamily\selectfont}
\setbeamerfont{framesubtitle}{family=\sffamily\selectfont}

\setbeamerfont{normal text}{family=\fontfamily{sansserif}\selectfont}

\setbeamerfont{section in toc}{family=\sffamily\selectfont}
\setbeamerfont{section in sidebar}{family=\sffamily\selectfont}




\addtobeamertemplate{navigation symbols}{}{%
    \usebeamerfont{footline}%
    \usebeamercolor[fg]{footline}%
    \hspace{1em}%
    \insertframenumber/\inserttotalframenumber
}

% \usefonttheme{professionalfonts}
\usefonttheme[stillsansseriftext,stillsansseriftitle]{serif}
% \usefonttheme[stillserifsmall,stillseriflarge,stillsansseriftext]{structurebold}



% FIXME: fonts note set correctly at each table of contents page
% Make the table of contents to pop up at
% the beginning of each subsection:
\AtBeginSection[]
{
    {
        \setbeamercolor{background canvas}{bg=WPIcrimson}
        \setbeamercolor{normal text}{fg=WPIgray}
        \setbeamercolor{structure}{fg=white}

        \setbeamercolor{section in toc shaded}{use=structure,fg=structure.fg}
        \setbeamercolor{section in toc}{fg=yellow}

        

        \begin{frame}<beamer>
%     \frametitle{Outline}
            
            \begin{columns}
                \begin{column}{0.45\textwidth}
                

            \tableofcontents[currentsection,hideothersubsections]
%         \tableofcontents[currentsection,currentsubsection,hideallsubsections]
            
        \end{column}
        \begin{column}{0.55\textwidth}
            
\noindent
\hfill
\includegraphics[width=\columnwidth]{fig/WPI_background_logo_corner.png}
            
        \end{column}
        \end{columns}

        \end{frame}
    }
}







% Helpful commands
% ----------------


% Highlight a line in an algorithm
\def\HiLi{\leavevmode\rlap{\hbox to \hsize{\color{yellow!50}\leaders\hrule height .8\baselineskip depth .5ex\hfill}}}

% Include a figure with a citation
\newcommand{\citeFigure}[2]{\includegraphics[width=\columnwidth]{fig/#1}\\%
\tiny\textcolor{lightgray}{Source: \cite{#2}}}
% FIXME: have citeFigure take the includegraphics [] argument (to specify a width, etc)


% Title slide
% -----------




\newcommand{\RBEtitleframe}[1][]{%

\pgfkeys{/myRBEtitleframe, default, #1}

\title[\scalebox{2}{\insertlogo}]{\myRBEtitleframeTitle\\\small{Lecture \myRBEtitleframeLectureNumber \\ \myRBEtitleframeCourseTitle}}



\author[]{\sffamily\textbf{\myRBEtitleframeAuthor}}

\institute[]
{\includegraphics[width=0.3\textwidth]{fig/WPI_Inst_Prim_FulClr.png}
}

\date{\textcolor{lightgray}{\tiny{Created: \today}}}


\begin{frame}[label=ROOT]
  \titlepage
\end{frame}

}




% Final pages
% -----------

\newcommand{\RBEfinalpages}{%


\setbeamercolor{background canvas}{bg=WPIcrimson}
\begin{frame}[label=lectureEndFrame]
 

\begin{center}
\includegraphics[height=\textheight]{fig/WPI_background_logo.png}
\end{center}

\end{frame}

\setbeamercolor{background canvas}{bg=white}
\begin{frame}[allowframebreaks,label=bibliography]
    \frametitle{Sources}

    \bibliographystyle{alpha}
    % \bibliographystyle{IEEEtran}
    \bibliography{/bib/RBE_resources.bib}

\end{frame}



\setbeamercolor{background canvas}{bg=WPIcrimson}
\begin{frame}[label=finalFrame]
 

\begin{center}
\includegraphics[height=\textheight]{fig/WPI_background_logo.png}
\end{center}

\end{frame}

 

}


