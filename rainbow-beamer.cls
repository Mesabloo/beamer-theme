\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rainbow-beamer}

\RequirePackage{pgfkeys, pgfopts}
\RequirePackage[abspath]{currfile}
\RequirePackage{xstring}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{tikz}

% Ensure luatex or xetex engine
\RequirePackage{iftex}
\RequireTUTeX%

\begingroup
\getabspath{rainbow-beamer.cls}%
\xdef\rainbow@path{\theabsdir}%
\endgroup

%%% Options

\newif\ifrainbow@debug
\newif\ifrainbow@nofonts
\newif\ifrainbow@withappendix
\let\rainbow@fonts@main\@empty
\let\rainbow@fonts@sans\@empty
\let\rainbow@fonts@mono\@empty
\let\rainbow@fonts@math\@empty
\let\rainbow@listings\@empty

\pgfkeys{/rainbow/.is family}
\pgfqkeys{/rainbow}{%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Imports the package `listings`, and include a
	% default style for the listings.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	listings/.store in=\rainbow@listings,
	listings/.initial={},
	%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Set these whenever you don't plan on using the 
	% shipped fonts.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	fonts/main/.store in=\rainbow@fonts@main,
	fonts/main/.initial=\@empty,
	fonts/sans/.store in=\rainbow@fonts@sans,
	fonts/sans/.initial=\@empty,
	fonts/mono/.store in=\rainbow@fonts@mono,
	fonts/mono/.initial=\@empty,
	fonts/math/.store in=\rainbow@fonts@math,
	fonts/math/.initial=\@empty,
	fonts/.is family,
	fonts/.code={\pgfqkeys{/rainbow/fonts}{#1}},
	%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Debugging option, please do not use.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	debug/.is if=rainbow@debug,
	debug/.initial=false,
	%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Will you use `\appendix'?
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	withappendix/.is if=rainbow@withappendix,
	withappendix/.initial=false,
	%
	% Give other options to beamer, but remove some
	.unknown/.code={%
			\PassOptionsToClass{\pgfkeyscurrentkey}{beamer}%
		},
}

\ProcessPgfOptions{/rainbow}

%% Load class
\LoadClass[
	aspectratio=169,
	noamssymb
]{beamer}



\mode<presentation>{\usetheme{rainbow}}


%% Setup listings, if required

\newif\ifrainbow@has@listings
\IfStrEq{\rainbow@listings}{\@empty}{}{%
	\rainbow@has@listingstrue
	\RequirePackage{listings-rainbow}
}

% Insert our title frame at the very beginning of the document
\AtBeginDocument{\begin{frame}[plain,noframenumbering]\maketitle\end{frame}}
% When debugging, insert a special frame right after
\ifrainbow@debug
	\AtBeginDocument{%
		\begin{frame}[noframenumbering]{{Debugging frame}}
			\begin{tabular}{r@{\ =\ }l}
				listings   & \rainbow@listings                    \\
				fonts/main & \rainbow@fonts@main                  \\
				fonts/sans & \rainbow@fonts@sans                  \\
				fonts/mono & \rainbow@fonts@mono                  \\
				fonts/math & \rainbow@fonts@math                  \\
				debug      & \ifrainbow@debug true \else false\fi
			\end{tabular}
		\end{frame}
	}
\fi


\AtBeginPart{\frame[plain,noframenumbering]{\partpage}}


\ifrainbow@withappendix
	\RequirePackage{appendixnumberbeamer}%

	\let\rainbow@oldappendix\appendix%
	\renewcommand\appendix{%
		\rainbow@oldappendix%
		\renewcommand{\insertframenumber}{\Alph{framenumber}}%
		\renewcommand{\theframenumber}{\Alph{framenumber}}%
		% \part{\appendixname}%
		\section*{\appendixname}%
	}%
\else
	\def\appendix{\ClassError{rainbow}{Appendices not supported without the `withappendix' option}{Please add the `withappendix' option to the class}}
\fi


\let\beamer@oldauthor\author
\renewcommand\author[2][]{%
	\@ifpackageloaded{hyperref}{
		\pdfstringdefDisableCommands{%
			\let\speaker\relax%
		}
	}{}
	\@ifpackageloaded{ulem}{
		\let\speaker\uline%
	}{%
		\let\speaker\underline%
	}%
	\beamer@oldauthor[#1]{#2}%
}


%%% Some useful defaults
\institute{Université de Lorraine \and CNRS \and Inria \and LORIA}
\titlegraphic{%
	\includegraphics[height=7mm]{\rainbow@path assets/logo_ul}
	\and%
	\includegraphics[height=7mm]{\rainbow@path assets/logo_cnrs}
	\and%
	\includegraphics[height=7mm]{\rainbow@path assets/logo_inria}
	\and%
	\includegraphics[height=7mm]{\rainbow@path assets/logo_loria}
}
\date{\today}



% \let\beamer@oldframe\frame
% \let\endbeamer@oldframe\endframe

\AtBeginSection{%
	\renewcommand{\subsecname}{}%
}

% TODO: why can't we just redefine the `frame` environment?
\renewenvironment<>{sframe}[1][]{%
	\begin{frame}#2[environment=sframe,#1]
		\expandafter\ifx\relax\secname\relax\else%
			\frametitle{\secname}%
		\fi%
		\expandafter\ifx\relax\subsecname\relax\else%
			\framesubtitle{\subsecname}%
		\fi%
		}{\end{frame}}

\newenvironment<>{sframe*}[1][]{%
	\begin{sframe}#2[noframenumbering,#1]
		}{\end{sframe}
}

\let\rainbow@oldagainframe\againframe%
\newcommand<>\rainbow@againframe[2][]{%
	\rainbow@oldagainframe#3[noframenumbering,#1]{#2}%
}
\renewcommand\againframe{\@ifstar\rainbow@oldagainframe\rainbow@againframe}


%%%% Various buttons

\newcommand*\rainbow@gotobutton[2]{\hyperlink{#1}{\beamergotobutton{#2}}}
\newcommand*\rainbow@returnbutton[2]{\hyperlink{#1}{\beamerreturnbutton{#2}}}
\newcommand*\rainbow@skipbutton[2]{\hyperlink{#1}{\beamerskipbutton{#2}}}
\newcommand*\button[1]{\beamerbutton{#1}}
\newcommand*\gotobutton{\@ifstar\beamergotobutton\rainbow@gotobutton}
\newcommand*\skipbutton{\@ifstar\beamerskipbutton\rainbow@skipbutton}
\newcommand*\returnbutton{\@ifstar\beamerreturnbutton\rainbow@returnbutton}