# Circuitikz

Este artigo é um compilado (em constante atualização) de dicas para o uso das bibliotecas Tikz e Circuitikz em editores latex, como o Overleaf, a fim de facilitar a criação de desenhos e esquemas; como diagramas elétricos e diagramas de blocos.

## Importando as bibliotecas necessárias
- Bibliotecas essenciais 
> Ferramenta para criar elementos gráficos
\usepackage{tikz} 	

> Esse pacote fornece macros de redes elétricas e elementos de circuitos elétricos
\usepackage{circuitikz}

- Bibliotecas secundárias

> Permite trabalhar com cores na criação dos elementos gráficos (não só eles).
\usepackage{xcolor}


## Iniciando qualquer circuito
Geralmente quando incluímos um circuito elétrico em um texto, queremos referenciá-lo como uma figura. Para isso, o elemento de circuito é criado dentro de uma figura. 

	\begin{figure}[]
	\begin{center}
	\resizebox{\textwidth}{!}{
		\begin{circuitikz}
			controles de criação do circuito;
		\end{circuitikz}
	}
	\end{center}
	\end{figure}
	

### Uso dos componentes como nós

Uma estratégia interessante para criar esquemas de circuitos eletrônicos é iniciar por um elemento físico, como um AmpOp, central ou mais à esquerda do circuito. 

\node\[ componente ](nome){escrita};
> componente: pode ser um amplificador operacional(op amp), um circulo sem preenchimento (ocirc),, uma fonte senoidal (sV), um terra(ground), etc. Opções de configuração desse componente também são adicionadas ao colchete, separadas por vírgula.

> nome: Dê um nome que será utilizado para fazer referência ao componente no decorrer do desenho. Preferencialmente siga o [Refence Designator](https://en.wikipedia.org/wiki/Reference_designator). Por exemplo, nomeie o primeiro amplificador operacional do circuito como U1.

> escrita: é o nome que aparecerá no desenho junto ao componente.

     \node [op amp](U1){\texttt{ampop}};
     
![ampop](https://github.com/Pinheirogustavo/Tips/blob/master/Circuitikz/imagens/A1.png)

Na linha seguinte, comece a ligar os componentes que estão conectados a este primeiro nó. O comando para iniciar o desenho é \draw

     \draw (U1.+) to [sV] ++(-6,0) coordinate(tmp)  node[ground] (GND){};
  
 Esse comando adiciona uma fonte senoidal [sV] saindo da entrada não inversora do AmpOp (U1.+) **para** essa fonte, localizada no centro entre essa entrada e a coordenada temporária  "coordinate(tmp)". A partir dessa coordenada tmp, é adicionado um terra. 

![ampop_fonte](https://github.com/Pinheirogustavo/Tips/blob/master/Circuitikz/imagens/A2.png)
  ![ampop_fonte_pontos](https://github.com/Pinheirogustavo/Tips/blob/master/Circuitikz/imagens/A2_PONTOS.png)

 ###### Coordenadas absolutas e relativas
 
 Podemos adicionar elementos de desenho em um ponto qualquer do ambiente iniciado com \begin{circuitikz} utilizando um par ordenado. 
 Quando utilizamos as coordenadas *absolutas*, basta usar o comando **(x,y)**. Já as coordenadas *relativas* são adicionadas após um componente ou nó com o comando **+(x,y)** ou **++(x,y)** .
 
	\begin{circuitikz}            
	    \draw (5,0)to[R=$R_1$] (7,0);
        \draw (5,-1)to[R=$R_2$] (7,-1);
        \draw (0,0)  node[ocirc]{referencial} +(-2,0) node[ocirc]{relativo};
        \draw (-2,-1)  node[ocirc]{absoluto};
	\end{circuitikz}

 
![absoluto e relativo](https://github.com/Pinheirogustavo/Tips/blob/master/Circuitikz/imagens/A7.png)

###### Criando os fios de conexão
Há várias formas de desenhar os fios de conexão. Nós já vimos uma quando criamos a fonte senoidal. Outras formas comuns, principalmente quando queremos fazer linhas verticais, longas, ortogonais ou conectar componentes que não estão na mesma linha são os comandos **- -** e **-|**.

 O primeiro comando criará uma linha reta entre a coordenada anterior e a próxima do script. O segundo realiza o mesmo desenho, mas é utilizada para criar fios ortogonais (quando a coordenada anterior e a posterior estão em planos verticais e horizontais diferentes, ou não guardam nenhuma ordenada em comum...).

	\draw(0,0) --++(2,0) --++(0,2) --++(2,0)-|(6,4);
	\draw(0,0) --++(2,0) --++(0,2) --++(2,0)|-(6,4);
Perceba que usamos coordenadas relativas e por último uma coordenada absoluta em ambos os exemplos.

Também usamos um comando levemente diferente em cada exemplo. Primeiro utilizamos o comando de fio ortogonal **-|** e depois **|-**. A diferença é que no primeiro exemplo primeiro é construído o segmento de reta horizontal e depois o vertical. No segundo exemplo a construção é primeiramente vertical e depois horizontal.

![construindo fios](https://github.com/Pinheirogustavo/Tips/blob/master/Circuitikz/imagens/A8.png)

**Outro modo de criar os fios de conexão como um próprio componente**, muito útil quando temos que identificar algum nó ou indicar correntes. O comando é **[short] **, que também possui diversas opções de configurações.

	\draw(0,0) to [short, -*, i=$I_0$] (2,0);
	
>-*: acrescenta um circulo (nó) ao final do fio.
>i=$I_0 $ : acrescenta uma seta e a legenda $I_O$ para a corrente.

![short](https://github.com/Pinheirogustavo/Tips/blob/master/Circuitikz/imagens/A11.png)
 
 ##### Utilizando as âncoras dos componentes para realizar as conexões
 
No passo anterior utilizamos o comando (U1.+) para realizar uma conexão a partir da entrada não inversora do amplificador operacional. Isso é possível com o uso das **âncoras/anchors** associadas a cada componente. Há dois modos de utilizar esse recurso:

- âncoras associadas com nós e pontos do componente.
A vantagem desse método é que a ligação entre componentes é realizada em pontos exatos, evitando erros de conexão nas figuras geradas. 
> Amplificadores Operacionais: possuem âncoras identicas aos pinos de seus CIs. Nome.âncora: (U1.out)

![âncoras do amplificador operacional](https://github.com/Pinheirogustavo/Tips/blob/master/Circuitikz/imagens/ancoras_ampop.png)

Podemos também usar as âncoras a partir de cordenadas.
> .north .south .east .west .north east . south west ...
> .left . center .right ... 
- âncoras associadas com o ângulo envolta do componente.
> Todos os componentes gráficos possuem âncoras ao seu redor que podem ser selecionadas com o ângulo referente.
Exemplo: ponto ao norte do componente X: X.90

![âncoras de borda](https://github.com/Pinheirogustavo/Tips/blob/master/Circuitikz/imagens/ancoras_graus.png)

 ##### Utilizando coordenadas temporárias para realizar as conexões
É vantajoso utilizar coordenadas temporárias para estabelecer nós que não são cruciais na identificação do circuito, assim como para realizar mudanças de direções nos conectores entre componentes. 

No comando anterior nós já usamos uma coordenada temporária (tmp), para definir o ponto em que seria conectado o nó ground.

Agora utlizamos novamente a coordenada temporária **coordinate(tmp)**, para adicionar um conector vertical na entrada inversora do ampop, que dá origem ao ramo de feedback.

	\draw (U1.-) to[short] ++(0,1) coordinate(tmp) to (tmp -| U1.out) to[short] (U1.out);

A figura a seguir deixa explícito o uso desse recurso: 

![coordenada_tmp](https://github.com/Pinheirogustavo/Tips/blob/master/Circuitikz/imagens/A4.png)

 ##### Utilizando coordenadas fixas para realizar conexões e identificar nós importantes no circuito.
 Ao criarmos uma coordenada como no caso anterior, podemos querer salvar o nó com um nome específico, pois ele será útil para novas conexões. Assim, ao invés de atualizarmos a mesma variável (tmp), criamos uma somente para aquele ponto, como no exemplo a seguir:
 
	   \draw (U1.out) to[short] ++(2,0) coordinate(saída);
Criamos uma coordenada fixa, chamada saída,  distante 2 cm da saída do amplificador. Esse nó será util em novas conexões e para ser destacado como um nó importante na análise do sinal. Novos usos desse recurso serão melhores explicados no decorrer do texto.

![enter image description here](https://github.com/Pinheirogustavo/Tips/blob/master/Circuitikz/imagens/A5.png)

 ##### Refinando o nosso primeiro circuito. Uso de opções de configuração de cada componente e destacando nós. 
 
Atualmente temos o seguinte circuito *buffer* desenhado, a partir do seguinte código: 

	\begin{figure}[]
	\begin{center}
	\resizebox{\textwidth}{!}{
		\begin{circuitikz}
	            \node [op amp](U1){\texttt{ampop}};
	            \draw (U1.+) to [sV] ++(-6,0) coordinate(tmp)  node[ground] (GND){};
	            \draw (U1.-) to[short] ++(0,1) coordinate(tmp) to (tmp -| U1.out) to[short] (U1.out);
	            \draw (U1.out) to[short] ++(2,0) coordinate(saída);
		\end{circuitikz}
	}
	\end{center}
	\end{figure}

![enter image description here](https://github.com/Pinheirogustavo/Tips/blob/master/Circuitikz/imagens/A6.png)

Você pode perceber alguns erros nessa apresentação, vamos refiná-la.

Podemos começar invertendo o desenho do ampop, para que a entrada inversora esteja na parte inferior. Um modo possível de realizar isso é com uso da opção de configuração  **noinv input up**.

	\node [op amp](U1){\texttt{ampop}};
	\node [op amp, noinv input up](U1){\texttt{ampop}};

A fonte de tensão senoidal também precisa ser deslocada para a posição vertical. Para isto, vamos usar as coordenadas temporárias.

	\draw (U1.+) to [sV] ++(-6,0) coordinate(tmp)  node[ground] (GND){};
	\draw (U1.+)  to[short] ++(-2,0)coordinate(tmp) to[sV] ++(0,-3)  node[ground] (GND){};
Devemos também deslocar o ramo de *feedback* para a parte inferior

	\draw (U1.-) to[short] ++(0,1) coordinate(tmp) to (tmp -| U1.out) to[short] (U1.out);
	\draw (U1.-) to[short] ++(0,-1) coordinate(tmp) to (tmp -| U1.out) to[short] (U1.out);

O resultado que temos é: 

	\begin{figure}[]
	\begin{center}
	\resizebox{\textwidth}{!}{
		\begin{circuitikz}
	            \node [op amp, noinv input up](U1){\texttt{ampop}};          
	            \draw (U1.+)  to[short] ++(-2,0)coordinate(tmp) to[sV] ++(0,-3)  node[ground] (GND){};            
	            \draw (U1.-) --++(0,-1) coordinate(tmp) to (tmp -| U1.out) to[short] (U1.out);
	            \draw (U1.out) to[short] ++(2,0) coordinate(saída);
		\end{circuitikz}
	}
	\end{center}
	\end{figure}

![buffer](https://github.com/Pinheirogustavo/Tips/blob/master/Circuitikz/imagens/A9.png)
	
Ainda podemos identificar os nós e explorar  outras configurações dos componentes:

	\begin{figure}[]
	\begin{center}
	\resizebox{\textwidth}{!}{
		\begin{circuitikz}
	            \node [op amp, noinv input up](U1){\texttt{ampop}};          
	            \draw (U1.+)  to[short,-*] ++(-2,0)coordinate(tmp) to[sV, l=$V_{in}$, fill=yellow] ++(0,-3)  node[ground] (GND){};          
	            \draw (U1.-) --++(0,-1) coordinate(tmp) to (tmp -| U1.out) to[short] (U1.out);
	            \draw (U1.out) to[short,-*, i=$I_{out}$] ++(2,0) coordinate(saída);

	            \draw (saída) to[short,-*, color=blue] + (0,0) node[shift={(0,0.5)}, color=blue] {saída};
	            \draw (tmp) to[short,-*, color=red] + (0,0) node[shift={(0,-0.5)}, color=red] {ultimo tmp};
	            \draw (U1.+) to[short,-*, color=green] + (0,0) node[shift={(0,+1)}, color=orange] {entrada não inversora};
	            
		\end{circuitikz}
	}
	\end{center}
	\end{figure}

![buffer_final](https://github.com/Pinheirogustavo/Tips/blob/master/Circuitikz/imagens/A10.png)

##### Componentes coloridos

Acabamos de ver como preencher com cores fontes senoidais. Agora vamos ver como colorir componentes, ferramenta útil para destacar algum elemento num esquema eletrônico.


	\begin{figure}[]
	\begin{center}
	\resizebox{\textwidth}{!}{
	    \begin{circuitikz}
	        \draw(0,0) to [C,l_=$C$,color=blue](0,2);	
			\draw[blue] (2,0) to [C,l_=$C$,color=blue] (2,2);
	        \draw(4,0) to[blue][C,l_=$C$](4,2);
	    \end{circuitikz}    
	}
	\end{center}
	\end{figure}

![componentes_coloridos](https://github.com/Pinheirogustavo/Tips/blob/master/Circuitikz/imagens/A11.png)

## Alguns artigos valiosos

#### Usando cores em seus desenhos

[Using colors in LaTeX](https://pt.overleaf.com/learn/latex/Using_colors_in_LaTeX)
