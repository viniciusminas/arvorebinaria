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

procedure CriarMunicipio(var arvmun: nodo_municipios; municipio: string);
var novoMun: nodo_municipios;
begin
    new(novoMun);
    novoMun^.desc_municipio := municipio;
    novoMun^.munesq := nil;
    novoMun^.mundir := nil;           
    novoMun^.munpai := nil;

    if arvmun = nil then
        arvmun := novoMun
    else
    begin
        if municipio < arvmun^.desc_municipio then
            CriarMunicipio(arvmun^.munesq, municipio)
        else
            CriarMunicipio(arvmun^.mundir, municipio);
    end;
end;

{function PosicionarMunicipio();
begin
end;

function VerificarUltimoMunicipio();
begin
end;}

procedure IncluirMunicipio(var arvraiz: nodo_estados; uf, municipio: string);
var est: nodo_estados;
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
	if est <> nil then
		CriarMunicipio(est^.municipio, municipio);
end;

{procedure ExcluirMunicipio();
begin
end;

procedure cadastrarMunicipio();
begin
end;} 
    
Begin
	IniciarVariaveis(estados);
  CriarEstado(estados, 'SC');
  CriarEstado(estados, 'SC');
  CriarEstado(estados, 'BB');
  CriarEstado(estados, 'ZZ');
  writeln;
  EmOrdem(estados);
End.
