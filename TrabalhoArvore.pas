Program Pzim ;

type                                                          
		arvore = ^nodo_arv;
    nodo_arv = Record
        conteudo: arvore;
        nome: string;
        arvdir, arvesq, arvpai: arvore;
    end;

var  estado : arvore;

Procedure ExibirNo(Raiz: arvore);
begin
	if Raiz <> nil then
	begin
		write(Raiz^.nome, ', ');
		ExibirNo(Raiz^.arvesq);
		ExibirNo(Raiz^.arvdir);
	end;
end;
	


Procedure EmOrdem(Raiz: arvore);
begin
    if Raiz <> nil then 
    begin
        EmOrdem(Raiz^.arvesq);
        write(Raiz^.nome, '-');
        EmOrdem(Raiz^.arvdir);
    end;
end;

Procedure EmOrdemMun(Raiz: arvore);
begin
    if Raiz <> nil then 
    begin
        EmOrdemMun(Raiz^.arvesq);
        write(Raiz^.nome, '-');
        EmOrdemMun(Raiz^.arvdir);
    end;
end;

Procedure PreOrdem(Raiz: arvore);
begin
    if Raiz <> nil then 
    begin
        write(Raiz^.nome, '-');
        ExibirNo(Raiz); //teste para mostrar os mun's.
        PreOrdem(Raiz^.arvesq);
        PreOrdem(Raiz^.arvdir);
    end;
end;

procedure IniciarVariaveis(var est: arvore);
begin
	est := nil;	
end; 

function VerificarNoExiste(arv: arvore; conteudo: string):arvore;
begin
	if arv = nil then
		VerificarNoExiste := nil
	else if arv^.nome = conteudo then //se o nome inserido ja existe no nó
		VerificarNoExiste := arv
	else if conteudo < arv^.nome then
	  VerificarNoExiste := VerificarNoExiste(arv^.arvesq, conteudo)
	else
      VerificarNoExiste := VerificarNoExiste(arv^.arvdir, conteudo);  
end;

function CriarNo(var arv, arvpai:arvore; conteudo: string): arvore;
var novoNo: arvore;
begin
    new(novoNo);
    novoNo^.nome := conteudo;
    novoNo^.arvesq := nil;
    novoNo^.arvdir := nil;           
    novoNo^.arvpai := nil;
    CriarNo := novoNo;

    if arv = nil then
    begin
        arv := novoNo;
        if arv <> arvpai then
        	arv^.arvpai := arvpai;
        CriarNo := arv;
    end
    else
    begin
        if conteudo < arv^.nome then
            CriarNo(arv^.arvesq, arv, conteudo)
        else
            CriarNo(arv^.arvdir, arv, conteudo);
    end;
end;

procedure IncluirMunicipio(var arvraiz: arvore; uf, municipio: string);
var 
		est: arvore;
begin
    est := VerificarNoExiste(arvraiz, uf);	
    if est = nil then
    begin
        est := CriarNo(arvraiz, arvraiz, uf);           
    end;
    
    writeln('Estado: ', est^.nome);

    while (est <> nil) and (est^.nome <> uf) do
    begin
        if uf < est^.nome then
            est := est^.arvesq
        else
            est := est^.arvdir;
    end;
	
	//condicional para adicionar o municipio na árvore desse estado
	if (est <> nil) and (VerificarNoExiste(est^.conteudo, municipio) = nil) then
		CriarNo(est^.conteudo, est^.conteudo, municipio)
	else
		writeln('Municipio já existe: ', municipio); //depuration, teste rs
end;

function AcharPosicao(var arvraiz: arvore; nome: string): arvore;
begin
	if (arvraiz^.nome < nome) then
	begin 	
		if (arvraiz^.arvdir = nil) then
			AcharPosicao := arvraiz
		else
			AcharPosicao := AcharPosicao(arvraiz^.arvdir, nome);	
	end
	else
	begin
		if (arvraiz^.arvesq = nil) then
			AcharPosicao := arvraiz
		else
			AcharPosicao := AcharPosicao(arvraiz^.arvesq, nome);	
	end
				
end;

procedure ExcluirCentral(pai, no:arvore);
var aux:arvore;
begin
	if pai^.nome < no^.nome then
	begin
		if no^.arvesq <> nil then
			pai^.arvdir := no^.arvesq
		else
			pai^.arvdir := no^.arvdir;		
		aux := AcharPosicao(no^.arvesq, no^.arvdir^.nome);
		aux^.arvdir := no^.arvdir;
		no^.arvdir^.arvpai := aux;
		if aux^.arvpai = no then
			aux^.arvpai := no^.arvpai;
		writeln('AUXPAI: ',aux^.arvpai^.nome);
		dispose(no);
	
	end
	else
	begin
		if no^.arvdir <> nil then 
			pai^.arvesq := no^.arvdir
		else 
			pai^.arvesq := no^.arvesq;  
			  
		aux := AcharPosicao(no^.arvdir, no^.arvesq^.nome);
		aux^.arvesq := no^.arvesq;
		no^.arvesq^.arvpai := aux;
		if aux^.arvpai = no then
			aux^.arvpai := no^.arvpai;
		writeln('AUXPAI: ',no^.arvesq^.arvpai^.nome);
		dispose(no);
	end

end;

procedure ExcluirFolha(pai, no:arvore);
begin
	if pai^.arvesq = no then
		pai^.arvesq := nil
	else
		pai^.arvdir := nil;
	dispose(no);
end;

procedure ExcluirNo(var estado: arvore; uf, municipio: string); 
var	no_exc, arv_exc, estado_exc: arvore;																																							 
begin
	estado_exc := VerificarNoExiste(estado, uf);
	writeln('Estado ', estado_exc^.nome);
	if estado_exc^.conteudo = nil then
		no_exc := estado_exc
	else 
		no_exc := VerificarNoExiste(estado_exc^.conteudo, municipio);
	
	writeln('PAI: ', no_exc^.arvpai^.nome, ' No exc: ', no_exc^.nome);
	writeln;
	if (no_exc^.arvpai = nil) then //Excluir Raiz
		writeln('Excluir Raiz')
	else if (no_exc^.arvesq = nil) and (no_exc^.arvdir = nil) then //Excluir folha
		ExcluirFolha(no_exc^.arvpai, no_exc)
	else
		ExcluirCentral(no_exc^.arvpai, no_exc);
end;

Begin  

	IniciarVariaveis(estado);
	IncluirMunicipio(estado, 'SC', 'Jaraguá');
	IncluirMunicipio(estado, 'SC', 'Ituporanga');
	IncluirMunicipio(estado, 'SC', 'Rio do Sul');
	IncluirMunicipio(estado, 'SC', 'AA');
	IncluirMunicipio(estado, 'SC', 'BB');
	IncluirMunicipio(estado, 'SC', 'AC');
	IncluirMunicipio(estado, 'SC', 'ZZ'); 
	CriarNo(estado, estado, 'SC');
	CriarNo(estado, estado, 'SP');
	CriarNo(estado, estado, 'MG');
	CriarNo(estado, estado, 'ZZ');
	CriarNo(estado, estado, 'PE');
	CriarNo(estado, estado, 'AA');
	CriarNo(estado, estado, 'BB');
	CriarNo(estado, estado, 'AC');
	CriarNo(estado, estado, 'NN');
	CriarNo(estado, estado, 'LL');
	EmOrdem(estado^.conteudo);
	writeln;
	ExcluirNo(estado, 'SC', 'Ituporanga');
	EmOrdem(estado^.conteudo);
	ExcluirNo(estado, 'SC', 'AA');
	EmOrdem(estado^.conteudo);

End.
