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

function VerificarEstadoExiste(arvraiz: nodo_estados; estuf: string): string;
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
  		if ref = estuf then
  		begin
  			VerificarEstadoExiste := 'Existe!';
  			achou := 1;
  		end
  		//Verifica Esquerda
  		else if estuf < ref then
  		begin
      	if aux = nil then
      	begin
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
				if aux = nil then
      	begin
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
var estraiz: nodo_estados;
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
		writeln(VerificarEstadoExiste(arvraiz, estuf));	
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
  CriarEstado(estados, 'AA');
  CriarEstado(estados, 'ZZ');
  write(estados^.uf);
End.
