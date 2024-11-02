Program Trabalho_arv ;
type
		nodo_municipios = ^nodo_mun;
    nodo_mun = Record
        sigla_uf: string;
        desc_municipio: string;
        munesq, munesq, munpai: nodo_municipios;
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

procedure IniciarVariaveis(var est: nodo_estados{; var mun: nodo_municipio});
begin
	est := nil;
	//mun :=nil;	
end;  

Procedure PreOrdem(Raiz: nodo_estados);
begin
    if Raiz <> nil then 
    begin
        write(Raiz^.uf, '-');
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
  		aux := auxant^.estesq;
  		if auxant^.uf = estuf then
  		begin
  			VerificarEstadoExiste := auxant;
  			//writeln('Existe');
  			achou := 1;
  		end
  		//Verifica Esquerda
  		else if estuf < auxant^.uf then
  		begin
      	if aux = nil then
      	begin
      		VerificarEstadoExiste := auxant;
      		writeln('Não existe. Posição à esquerda de: ', auxant^.uf);
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
      		writeln('Não existe. Posição à direita de: ', auxant^.uf);
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
				
			writeln('Novo Estado: ', NovoEstado^.uf);
		end;
				
	end;
		
end;

function AcharPosicao(var arvraiz: nodo_estados; estuf: string): nodo_estados;
begin
	if (arvraiz^.uf < estuf) then
	begin 	
		if (arvraiz^.estdir = nil) then
			AcharPosicao := arvraiz
		else
			AcharPosicao(arvraiz^.estdir, estuf);	
	end
	else
	begin
		if (arvraiz^.estesq = nil) then
			AcharPosicao := arvraiz
		else
			AcharPosicao(arvraiz^.estesq, estuf);	
	end
				
end;

procedure ExcluirEstado(var arvraiz: nodo_estados;estuf: string);
var estado, aux: nodo_estados;
begin
	if arvraiz^.uf = estuf then
	begin
		writeln('Raiz da Árvore');
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
						writeln(estado^.estpai^.estdir^.uf, ' ', estado^.estpai^.estesq^.uf);
						aux := AcharPosicao(estado^.estesq, estado^.estdir^.uf);
						aux^.estdir := estado^.estdir;
						estado^.estdir^.estpai := aux;
						estado^.estesq^.estdir := estado^.estdir;
						dispose(estado);
						//writeln('Novo Pai: ', AcharPosicao(estado^.estesq, estuf)^.uf);
					end
					else
					begin
						if estado^.estdir <> nil then 
							estado^.estpai^.estesq := estado^.estdir
						else
							estado^.estpai^.estesq := estado^.estesq;
							
						writeln(estado^.estpai^.estdir^.uf, ' ', estado^.estpai^.estesq^.uf);
						aux := AcharPosicao(estado^.estdir, estado^.estesq^.uf);
						aux^.estesq := estado^.estesq;
						estado^.estesq^.estpai := aux;
						estado^.estdir^.estesq := estado^.estesq;
						dispose(estado);
						writeln(arvraiz^.estdir^.estesq^.uf, ' ', arvraiz^.estdir^.estdir^.uf);
					end
				end;	
			end
		else
			writeln('Não da para excluir');	
	end;
end;
		{
function CriarMunicipio();
begin
end;

function PosicionarMunicipio();
begin
end;

function VerificarUltimoMunicipio();
begin
end;

procedure IncluirMunicipio();
begin
end;

procedure ExcluirMunicipio();
begin
end;

procedure cadastrarMunicipio();
begin
end;  }
    
Begin
	IniciarVariaveis(estados);
  CriarEstado(estados, 'SC');
  CriarEstado(estados, 'SC');
  CriarEstado(estados, 'BB');
  CriarEstado(estados, 'VV');
  CriarEstado(estados, 'YY');
  CriarEstado(estados, 'ZZ');
  CriarEstado(estados, 'TT');
  CriarEstado(estados, 'RR');
  CriarEstado(estados, 'SB');
  CriarEstado(estados, 'SS');
  CriarEstado(estados, 'UU');
  CriarEstado(estados, 'XX');
  
  writeln;
  EmOrdem(estados);
  writeln;
  ExcluirEstado(estados, 'ZZ');
  writeln;
  EmOrdem(estados); 
End.
