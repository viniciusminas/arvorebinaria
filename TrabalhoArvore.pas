Program Trabalho_arv;                                                    
type                                                          
		nodo_municipios = ^nodo_mun;
    nodo_mun = Record
        sigla_uf: string;
        desc_municipio: string;
        mundir, munesq, munpai: nodo_municipios;
    end;
    
    nodo_estados = ^nodo_est;
    nodo_est = Record
        uf: string;
        municipio: nodo_municipios;
        estesq, estdir, estpai: nodo_estados;
    End;
  
var
	estados: nodo_estados;
	
Procedure EmOrdem(Raiz: nodo_estados);
begin
    if Raiz <> nil then 
    begin
        EmOrdem(Raiz^.estesq);
        write(Raiz^.uf, '-');
        EmOrdem(Raiz^.estdir);
    end;
end;

Procedure EmOrdemMun(Raiz: nodo_municipios);
begin
    if Raiz <> nil then 
    begin
        EmOrdemMun(Raiz^.munesq);
        write(Raiz^.desc_municipio, '-');
        EmOrdemMun(Raiz^.mundir);
    end;
end;

procedure IniciarVariaveis(var est: nodo_estados{; var mun: nodo_municipio});
begin
	est := nil;
	//mun :=nil;	
end;  

Procedure ExibirMunicipios(RaizMunicipio: nodo_municipios);
begin
	if RaizMunicipio <> nil then
	begin
		write(RaizMunicipio^.desc_municipio, ', ');
		ExibirMunicipios(RaizMunicipio^.munesq);
		ExibirMunicipios(RaizMunicipio^.mundir);
	end;
end;

Procedure PreOrdem(Raiz: nodo_estados);
begin
    if Raiz <> nil then 
    begin
        write(Raiz^.uf, '-');
        ExibirMunicipios(Raiz^.municipio); //teste para mostrar os mun's.
        PreOrdem(Raiz^.estesq);
        PreOrdem(Raiz^.estdir);
    end;
end;

function VerificarEstadoExiste(arvraiz: nodo_estados; estuf: string): nodo_estados;
var achou: integer;
		ref: string;
		auxant, aux: nodo_estados;
begin 
    ref := arvraiz^.uf;
  	auxant := arvraiz;
  	aux := arvraiz^.estesq;		
  	achou := 0;
  	while achou = 0 do
  	begin
  		if auxant^.uf = estuf then
  		begin
  			VerificarEstadoExiste := auxant;
  			achou := 1;
  		end
  		else if estuf < auxant^.uf then
  		begin
      	if aux = nil then
      	begin
      		VerificarEstadoExiste := auxant;
      		achou := 1;
      	end
      	else
      	begin
      		auxant := aux;
					aux := aux^.estesq;
      	end
      end
      else
			begin
				aux := auxant^.estdir;
				if aux = nil then
      	begin
      		VerificarEstadoExiste := auxant;
      		achou := 1;
      	end
      	else
      	begin
      		auxant := aux;
					aux := aux^.estdir;
      	end
			end	
  	end
end;


function VerificarMunicipioExiste(arvmun: nodo_municipios; municipio: string):nodo_municipios;
begin
	if arvmun = nil then
		VerificarMunicipioExiste := nil
	else if arvmun^.desc_municipio = municipio then //se o nome inserido ja existe no nó
		VerificarMunicipioExiste := arvmun
	else if municipio < arvmun^.desc_municipio then
	  VerificarMunicipioExiste := VerificarMunicipioExiste(arvmun^.munesq, municipio)
	else
      VerificarMunicipioExiste := VerificarMunicipioExiste(arvmun^.mundir, municipio);
end; 

procedure CriarEstado(var arvraiz: nodo_estados; estuf: string);
var estraiz, estado, NovoEstado: nodo_estados;
begin
	new(estraiz);
	
	if arvraiz = nil then
	begin
		arvraiz := estraiz;
		arvraiz^.estesq := nil;
		arvraiz^.estdir := nil;
		arvraiz^.estpai := nil;
		arvraiz^.municipio := nil;
		arvraiz^.uf := estuf;
	end
	else 
	begin 
		estado := VerificarEstadoExiste(arvraiz, estuf);	
		if (estado^.uf = estuf) then
			writeln('O estado já existe: ', estado^.uf)
		else
		begin
			new(NovoEstado);
			NovoEstado^.uf := estuf;
			NovoEstado^.estpai := estado;
			NovoEstado^.estesq := nil;
			NovoEstado^.estdir := nil;
			if estado^.uf > NovoEstado^.uf then
				estado^.estesq := NovoEstado
			else
				estado^.estdir := NovoEstado;
		end;
				
	end;
		
end;

procedure CriarMunicipio(var arvmun, arvpai: nodo_municipios; municipio: string);
var novoMun: nodo_municipios;
begin
    new(novoMun);
    novoMun^.desc_municipio := municipio;
    novoMun^.munesq := nil;
    novoMun^.mundir := nil;           
    novoMun^.munpai := nil;

    if arvmun = nil then
    begin
        arvmun := novoMun;
        arvmun^.munpai := arvpai;
    end
    else
    begin
        if municipio < arvmun^.desc_municipio then
            CriarMunicipio(arvmun^.munesq, arvmun, municipio)
        else
            CriarMunicipio(arvmun^.mundir, arvmun, municipio);
    end;
end;


function AcharPosicao(var arvraiz: nodo_estados; estuf: string): nodo_estados;
begin
	if (arvraiz^.uf < estuf) then
	begin 	
		if (arvraiz^.estdir = nil) then
			AcharPosicao := arvraiz
		else
			AcharPosicao := AcharPosicao(arvraiz^.estdir, estuf);	
	end
	else
	begin
		if (arvraiz^.estesq = nil) then
			AcharPosicao := arvraiz
		else
			AcharPosicao := AcharPosicao(arvraiz^.estesq, estuf);	
	end
				
end;

function AcharPosicaoMun(var arvraiz: nodo_municipios; descmun: string): nodo_municipios;
begin
	if (arvraiz^.desc_municipio < descmun) then
	begin 	
		if (arvraiz^.mundir = nil) then
			AcharPosicaoMun := arvraiz
		else
			AcharPosicaoMun := AcharPosicaoMun(arvraiz^.mundir, descmun);	
	end
	else
	begin
		if (arvraiz^.munesq = nil) then
			AcharPosicaoMun := arvraiz
		else
			AcharPosicaoMun := AcharPosicaoMun(arvraiz^.munesq, descmun);	
	end
				
end;

function ExcluirRaizArvore(var arvraiz:nodo_estados): nodo_estados;
var aux, NovaRaiz : nodo_estados;
begin
	if arvraiz^.estdir <> nil then
	begin
		NovaRaiz := arvraiz^.estdir;
		NovaRaiz^.estpai := nil;
		if arvraiz^.estesq <> nil then
		begin
			writeln(NovaRaiz^.uf);
			aux := AcharPosicao(NovaRaiz, arvraiz^.estesq^.uf);
			writeln(aux^.uf);
			aux^.estesq := arvraiz^.estesq;
			arvraiz^.estesq^.estpai := aux;
		end;
		
	end
	else if arvraiz^.estesq <> nil then
	begin
		NovaRaiz := arvraiz^.estesq
	end;
	dispose(arvraiz);
	ExcluirRaizArvore := NovaRaiz;	
		
end;

function ExcluirRaizMun(var arvraiz:nodo_municipios): nodo_municipios;
var aux, NovaRaiz : nodo_municipios;
begin
	if arvraiz^.mundir <> nil then
	begin
		NovaRaiz := arvraiz^.mundir;
		NovaRaiz^.munpai := nil; 
		if arvraiz^.munesq <> nil then
		begin
			writeln(NovaRaiz^.desc_municipio);
			aux := AcharPosicaoMun(NovaRaiz, arvraiz^.munesq^.desc_municipio);
			writeln(aux^.desc_municipio);
			aux^.munesq := arvraiz^.munesq;
			arvraiz^.munesq^.munpai := aux;
		end;
		
	end
	else if arvraiz^.munesq <> nil then
	begin
		NovaRaiz := arvraiz^.munesq
	end;
	dispose(arvraiz);
	ExcluirRaizMun := NovaRaiz;	
		
end; 

procedure ExcluirEstado(var arvraiz: nodo_estados;estuf: string);
var estado, aux: nodo_estados;
begin
	if arvraiz^.uf = estuf then
	begin
		arvraiz := ExcluirRaizArvore(arvraiz);
	end
	else
	begin
		estado := VerificarEstadoExiste(arvraiz, estuf);
		if (estado^.uf = estuf) then
			begin
				if (estado^.estesq = nil) and (estado^.estdir = nil) then
				begin
					if estado = estado^.estpai^.estesq then
						estado^.estpai^.estesq := nil	
					else
					  estado^.estpai^.estdir := nil;
					dispose(estado);
				end
				else
				begin
					if estado^.estpai^.uf < estado^.uf then
					begin
						if estado^.estesq <> nil then
							estado^.estpai^.estdir := estado^.estesq
						else
							estado^.estpai^.estdir := estado^.estdir;
						aux := AcharPosicao(estado^.estesq, estado^.estdir^.uf);
						aux^.estdir := estado^.estdir;
						if aux^.estpai = estado then
							aux^.estpai := estado^.estpai;
						estado^.estdir^.estpai := aux;
						dispose(estado);
					
					end
					else
					begin
						if estado^.estdir <> nil then 
							estado^.estpai^.estesq := estado^.estdir
						else 
							estado^.estpai^.estesq := estado^.estesq;    
						aux := AcharPosicao(estado^.estdir, estado^.estesq^.uf);
						aux^.estesq := estado^.estesq;
						if aux^.estpai = estado then
							aux^.estpai := estado^.estpai;	
						estado^.estesq^.estpai := aux;
						dispose(estado);
					end
				end;	
			end
		else
			writeln('Não da para excluir');	
	end;
end;

procedure ExcluirMunicipio(var estraiz:nodo_estados; descmun, estuf: string);
var municipio, aux: nodo_municipios; 
    estado: nodo_estados;
    escluirEst : boolean;
begin
	escluirEst := false;
	estado := VerificarEstadoExiste(estraiz, estuf);
	writeln('estmun: ', estado^.municipio^.desc_municipio);
	municipio := VerificarMunicipioExiste(estado^.municipio, descmun);
	writeln;
	writeln;
	writeln(estado^.uf);
	writeln(municipio^.desc_municipio);
	writeln('aqui: ', estuf, ' ', descmun);
	writeln;
	if municipio^.desc_municipio = descmun then
	begin
		writeln('Municipio: ', municipio^.desc_municipio);
		writeln;
		if municipio^.desc_municipio = estraiz^.municipio^.desc_municipio then
		begin
				if (municipio^.munesq = nil) and (municipio^.mundir = nil) then
					escluirEst := true;
				estado^.municipio :=  ExcluirRaizMun(municipio);
				if escluirEst = true then
					ExcluirEstado(estraiz, estuf);
		end
		else
		begin
			if (municipio^.munesq = nil) and (municipio^.mundir = nil) then
				begin
					if municipio = municipio^.munpai^.munesq then
						municipio^.munpai^.munesq := nil	
					else
					  municipio^.munpai^.mundir := nil;
					dispose(municipio);
				end
			else
			begin
					if municipio^.munpai^.desc_municipio < municipio^.desc_municipio then
					begin
						if municipio^.munesq <> nil then
							municipio^.munpai^.mundir := municipio^.munesq
						else
							municipio^.munpai^.mundir := municipio^.mundir;
						aux := AcharPosicaoMun(municipio^.munesq, municipio^.mundir^.desc_municipio);
						writeln('Aux: ', aux^.desc_municipio);
						aux^.mundir := municipio^.mundir;
						municipio^.mundir^.munpai := aux;
						if aux^.munpai = municipio then
							aux^.munpai := municipio^.munpai;
						writeln('paiesq: ', municipio^.munpai^.desc_municipio);
						dispose(municipio);
					
					end
					else
					begin
						if municipio^.mundir <> nil then 
							municipio^.munpai^.munesq := municipio^.mundir
						else 
							municipio^.munpai^.munesq := municipio^.munesq;    
						aux := AcharPosicaoMun(municipio^.mundir, municipio^.munesq^.desc_municipio);
						writeln('Aux2: ', aux^.desc_municipio);
						aux^.munesq := municipio^.munesq;
						municipio^.munesq^.munpai := aux;
						if aux^.munpai = municipio then
							aux^.munpai := municipio^.munpai;
						writeln('paiesq: ', aux^.munpai^.desc_municipio);
						dispose(municipio);
					end
			end
		end		
	end
	else
		writeln('Município não existe!');
	 
	
	
end;

{function PosicionarMunicipio();
begin
end;

function VerificarUltimoMunicipio();
begin
end;}

procedure IncluirMunicipio(var arvraiz: nodo_estados; uf, municipio: string);
var 
		est: nodo_estados;
begin
    est := arvraiz;
			
    if VerificarEstadoExiste(arvraiz, uf)^.uf <> uf then
        CriarEstado(arvraiz, uf);

    while (est <> nil) and (est^.uf <> uf) do
    begin
        if uf < est^.uf then
            est := est^.estesq
        else
            est := est^.estdir;
    end;
	
	//condicional para adicionar o municipio na árvore desse estado
	if (est <> nil) and (VerificarMunicipioExiste(est^.municipio, municipio) = nil) then
		CriarMunicipio(est^.municipio, est^.municipio, municipio)
	else
		writeln('Municipio já existe: ', municipio); //depuration, teste rs
end;

{procedure ExcluirMunicipio();
begin
end;

procedure cadastrarMunicipio();
begin
end;}

procedure ProcessarOpcao();
var
	op: integer;
	uf, municipio: string;
begin
	repeat
		writeln('0 - FECHAR PROGRAMA ');
		writeln('1 - INSERE MUNICIPIO');
		writeln('2 - EXIBIR ARVORE EM ORDEM');
		writeln('3 - EXIBIR ARVORE EM ORDEM OS MUNICIPIOS');
		writeln('4 - EXCLUSAO');
		write('Escolha uma opção: ');
		readln(op);
	
		case op of
			 
			1: begin
					writeln('Digite a sigla do estado: ');                   
					readln(uf);
					writeln('Digite o nome do município: ' );
					readln(municipio);
					IncluirMunicipio(estados, uf, municipio);
			    writeln;
					writeln(estados^.uf);
					writeln(estados^.municipio^.desc_municipio);
			   end;
			 
			2: begin
					clrscr;
					writeln('Exibindo árvore em ordem:');
					clrscr;
					EmOrdem(estados);
					writeln;
			   end;
			 
			3: begin
				  clrscr;
					writeln('Exibindo árvore em ordem:');
					EmOrdemMun(estados^.municipio);
					writeln;
					writeln('Pai: ', estados^.municipio^.munesq^.munpai^.desc_municipio);
					writeln;
			   end;
			
			4: begin
					 writeln('Digite o município a ser excluido: ');
					 readln(municipio);
					 writeln('Digite o estado do município a ser excluido: ');
					 readln(uf);
					 ExcluirMunicipio(estados, municipio, uf);
				 end;
			
			0: writeln('Saindo do programa...');
			
			else
				writeln('Opção inválida. Tente novamente.');
		end;
	until op = 0;
end;

    
Begin

  IniciarVariaveis(estados);
	IncluirMunicipio(estados, 'SP', 'MM');
	IncluirMunicipio(estados, 'SP', 'MM');
	IncluirMunicipio(estados, 'SP', 'EE');
	IncluirMunicipio(estados, 'SP', 'SS');
	IncluirMunicipio(estados, 'SP', 'CC');
	IncluirMunicipio(estados, 'SP', 'BB');
	IncluirMunicipio(estados, 'SP', 'DD');
	IncluirMunicipio(estados, 'SP', 'AA');
	IncluirMunicipio(estados, 'SP', 'FF');
	IncluirMunicipio(estados, 'SP', 'YY');
	IncluirMunicipio(estados, 'SP', 'ZZ');
	IncluirMunicipio(estados, 'SP', 'NN');
	IncluirMunicipio(estados, 'SP', 'OO');
	IncluirMunicipio(estados, 'SP', 'NA');
	
	IncluirMunicipio(estados, 'RJ', 'Rio de Janeiro');
	IncluirMunicipio(estados, 'RJ', 'Niterói');
	IncluirMunicipio(estados, 'RJ', 'Nova Iguaçu');
	IncluirMunicipio(estados, 'RJ', 'Duque de Caxias');
	IncluirMunicipio(estados, 'RJ', 'Volta Redonda');
	IncluirMunicipio(estados, 'RJ', 'Macaé');
	IncluirMunicipio(estados, 'RJ', 'Cabo Frio');
	IncluirMunicipio(estados, 'RJ', 'Campos dos Goytacazes');
	IncluirMunicipio(estados, 'RJ', 'Teresópolis');
	IncluirMunicipio(estados, 'RJ', 'Petrópolis');
	
	IncluirMunicipio(estados, 'MG', 'Belo Horizonte');
	IncluirMunicipio(estados, 'MG', 'Uberlândia');
	IncluirMunicipio(estados, 'MG', 'Contagem');
	IncluirMunicipio(estados, 'MG', 'Juiz de Fora');
	IncluirMunicipio(estados, 'MG', 'Betim');
	IncluirMunicipio(estados, 'MG', 'Ipatinga');
	IncluirMunicipio(estados, 'MG', 'Montes Claros');
	IncluirMunicipio(estados, 'MG', 'Governador Valadares');
	IncluirMunicipio(estados, 'MG', 'Sete Lagoas');
	IncluirMunicipio(estados, 'MG', 'Divinópolis');
	
	IncluirMunicipio(estados, 'RS', 'Porto Alegre');
	IncluirMunicipio(estados, 'RS', 'Caxias do Sul');
	IncluirMunicipio(estados, 'RS', 'Pelotas');
	IncluirMunicipio(estados, 'RS', 'Santa Maria');
	IncluirMunicipio(estados, 'RS', 'Gravataí');
	IncluirMunicipio(estados, 'RS', 'Rio Grande');
	IncluirMunicipio(estados, 'RS', 'Novo Hamburgo');
	IncluirMunicipio(estados, 'RS', 'Santa Cruz do Sul');
	IncluirMunicipio(estados, 'RS', 'São Leopoldo');
	IncluirMunicipio(estados, 'RS', 'Bagé');
	
	IncluirMunicipio(estados, 'BA', 'Salvador');
	IncluirMunicipio(estados, 'BA', 'Feira de Santana');
	IncluirMunicipio(estados, 'BA', 'Vitória da Conquista');
	IncluirMunicipio(estados, 'BA', 'Camaçari');
	IncluirMunicipio(estados, 'BA', 'Itabuna');
	IncluirMunicipio(estados, 'BA', 'Juazeiro');
	IncluirMunicipio(estados, 'BA', 'Lauro de Freitas');
	IncluirMunicipio(estados, 'BA', 'Ilhéus');
	IncluirMunicipio(estados, 'BA', 'Porto Seguro');
	IncluirMunicipio(estados, 'BA', 'Teixeira de Freitas');
	
	IncluirMunicipio(estados, 'PR', 'Curitiba');
	IncluirMunicipio(estados, 'PR', 'Londrina');
	IncluirMunicipio(estados, 'PR', 'Maringá');
	IncluirMunicipio(estados, 'PR', 'Ponta Grossa');
	IncluirMunicipio(estados, 'PR', 'Cascavel');
	IncluirMunicipio(estados, 'PR', 'São José dos Pinhais');
	IncluirMunicipio(estados, 'PR', 'Foz do Iguaçu');
	IncluirMunicipio(estados, 'PR', 'Araucária');
	IncluirMunicipio(estados, 'PR', 'Toledo');
	IncluirMunicipio(estados, 'PR', 'Colombo');
	
	IncluirMunicipio(estados, 'PE', 'Recife');
	IncluirMunicipio(estados, 'PE', 'Olinda');
	IncluirMunicipio(estados, 'PE', 'Jaboatão dos Guararapes');
	IncluirMunicipio(estados, 'PE', 'Caruaru');
	IncluirMunicipio(estados, 'PE', 'Petrolina');
	IncluirMunicipio(estados, 'PE', 'Garanhuns');
	IncluirMunicipio(estados, 'PE', 'Igarassu');
	IncluirMunicipio(estados, 'PE', 'São Lourenço da Mata');
	IncluirMunicipio(estados, 'PE', 'Aglomeração Urbana do Recife');
	IncluirMunicipio(estados, 'PE', 'Timbaúba');
	
	IncluirMunicipio(estados, 'CE', 'Fortaleza');
	IncluirMunicipio(estados, 'CE', 'Caucaia');
	IncluirMunicipio(estados, 'CE', 'Juazeiro do Norte');
	IncluirMunicipio(estados, 'CE', 'Sobral');
	IncluirMunicipio(estados, 'CE', 'Maracanaú');
	IncluirMunicipio(estados, 'CE', 'Crato');
	IncluirMunicipio(estados, 'CE', 'Iguatu');
	IncluirMunicipio(estados, 'CE', 'Quixadá');
	IncluirMunicipio(estados, 'CE', 'Aquiraz');
	IncluirMunicipio(estados, 'CE', 'Pacajus');
	
	IncluirMunicipio(estados, 'GO', 'Goiânia');
	IncluirMunicipio(estados, 'GO', 'Aparecida de Goiânia');
	IncluirMunicipio(estados, 'GO', 'Anápolis');
	IncluirMunicipio(estados, 'GO', 'Rio Verde');
	IncluirMunicipio(estados, 'GO', 'Goiatuba');
	IncluirMunicipio(estados, 'GO', 'Jataí');
	IncluirMunicipio(estados, 'GO', 'Catalão');
	IncluirMunicipio(estados, 'GO', 'Senador Canedo');
	IncluirMunicipio(estados, 'GO', 'Formosa');
	IncluirMunicipio(estados, 'GO', 'Luziânia');
	
	IncluirMunicipio(estados, 'SC', 'Florianópolis');
	IncluirMunicipio(estados, 'SC', 'Joinville');
	IncluirMunicipio(estados, 'SC', 'Blumenau');
	IncluirMunicipio(estados, 'SC', 'Chapecó');
	IncluirMunicipio(estados, 'SC', 'Criciúma');
	IncluirMunicipio(estados, 'SC', 'São José');
	IncluirMunicipio(estados, 'SC', 'Lages');
	IncluirMunicipio(estados, 'SC', 'Itajaí');
	IncluirMunicipio(estados, 'SC', 'Balneário Camboriú');
	IncluirMunicipio(estados, 'SC', 'Jaraguá do Sul');
	writeln(estados^.estesq^.municipio^.desc_municipio);
	ProcessarOpcao;
End.
