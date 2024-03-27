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
	

### Uso dos componentes como nós

Uma estratégia interessante para criar esquemas de circuitos eletrônicos é iniciar por um elemento físico, como um AmpOp, central ou mais à esquerda do circuito. 

\node\[ componente ](nome){escrita};
> componente: pode ser um amplificador operacional(op amp), um circulo sem preenchimento (ocirc),, uma fonte senoidal (sV), um terra(ground), etc. Opções de configuração desse componente também são adicionadas ao colchete, separadas por vírgula.

> nome: Dê um nome que será utilizado para fazer referência ao componente no decorrer do desenho. Preferencialmente siga o [Refence Designator](https://en.wikipedia.org/wiki/Reference_designator). Por exemplo, nomeie o primeiro amplificador operacional do circuito como U1.

> escrita: é o nome que aparecerá no desenho junto ao componente.

    \node [op amp](U1){\texttt{buffer}};

Na linha seguinte, comece a ligar os componentes que estão conectados a este primeiro nó. O comando para iniciar o desenho é \draw

     \draw (U1.+) to [sV] ++(-6,0) coordinate(tmp)  node[ground] (GND){};
  
 Esse comando adiciona uma fonte senoidal [sV] saindo da entrada não inversora do AmpOp (U1.+) **para** essa fonte, localizada no centro entre essa entrada e a coordenada temporária  "coordinate(tmp)". A partir dessa coordenada tmp, é adicionado um terra. 
 
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


