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

procedure VerificarEstadoExiste();
begin 
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
  write(estados^.uf);
End.