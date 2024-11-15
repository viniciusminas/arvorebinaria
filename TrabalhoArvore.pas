Program Pzim ;

type                                                          
		arvore = ^nodo_arv;
    nodo_arv = Record
        conteudo: arvore;
        nome: string;
        arvdir, arvesq, arvpai: arvore;
    end;

var  estado, est, mun : arvore;
     opcao:integer;
     uf, municipio:string;

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
Procedure ExibirMunicipios(RaizMunicipio: arvore);
begin
	if RaizMunicipio <> nil then
	begin
		ExibirMunicipios(RaizMunicipio^.arvesq);
		write(RaizMunicipio^.nome, ', ');
		ExibirMunicipios(RaizMunicipio^.arvdir);
	end;
end;
Procedure PreOrdem(Raiz: arvore);
begin
    if Raiz <> nil then 
    begin
        write(Raiz^.nome, '-');
        write('  | Raiz: ', Raiz^.conteudo^.nome, ' | Municípios: ');
        ExibirMunicipios(Raiz^.conteudo); //teste para mostrar os mun's.
        writeln;
        writeln;
        PreOrdem(Raiz^.arvesq); 
        PreOrdem(Raiz^.arvdir);
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
Procedure Contar(Raiz: arvore; var count: integer);
begin
    if Raiz <> nil then 
    begin
        Contar(Raiz^.arvesq, count);
        count := count + 1; // realiza a contagem
        Contar(Raiz^.arvdir, count);
    end;
end;
procedure ContarMunicipiosPorEstado(raizEstado: arvore);
var
    totalMunicipios: integer;
begin
    if raizEstado <> nil then
    begin
        ContarMunicipiosPorEstado(raizEstado^.arvesq);  // acessar  o no filho esquerdo desta UF

        totalMunicipios := 0;  // carrega novamente
        Contar(raizEstado^.conteudo, totalMunicipios);  // contagem de municipios do UF
        
        writeln('Estado: ', raizEstado^.nome, ' - Municípios cadastrados: ', totalMunicipios);  // AMOSTRA
        
        ContarMunicipiosPorEstado(raizEstado^.arvdir);
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
function CriarNo(var arv:arvore; arvpai:arvore; conteudo: string): arvore;
var novoNo: arvore;
begin
    if arv = nil then
    begin
    	new(novoNo);
	    novoNo^.nome := conteudo;
	    novoNo^.arvesq := nil;
	    novoNo^.arvdir := nil;           
	    novoNo^.arvpai := nil;
	    //CriarNo := novoNo;

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
		est, estado: arvore;
begin
    est := VerificarNoExiste(arvraiz, uf);	
    if est = nil then
    begin
        CriarNo(arvraiz, arvraiz^.arvpai, uf);           
    end;
    est := VerificarNoExiste(arvraiz, uf);
    
    while (est <> nil) and (est^.nome <> uf) do
    begin
        if uf < est^.nome then
            est := est^.arvesq
        else
            est := est^.arvdir;
    end;
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
		begin
			pai^.arvdir := no^.arvesq;
			no^.arvesq^.arvpai := pai;
			if no^.arvdir <> nil then
			begin
				aux := AcharPosicao(no^.arvesq, no^.arvdir^.nome);
				aux^.arvdir := no^.arvdir;
				if aux^.arvpai = no then
					aux^.arvpai := no^.arvpai;				
				no^.arvdir^.arvpai := aux;
			end
		end
		else
		begin
			pai^.arvdir := no^.arvdir;		
			no^.arvdir^.arvpai := no^.arvpai;
		end;
		dispose(no);
	
	end
	else
	begin
		if no^.arvdir <> nil then 
		begin
			pai^.arvesq := no^.arvdir;
			no^.arvdir^.arvpai := pai;
			if no^.arvesq <> nil then
			begin
				aux := AcharPosicao(no^.arvdir, no^.arvesq^.nome);
				aux^.arvesq := no^.arvesq;
				
				if aux^.arvpai = no then
					aux^.arvpai := no^.arvpai;
				no^.arvesq^.arvpai := aux;
			end
		end
		else
		begin 
			pai^.arvesq := no^.arvesq;  
		  no^.arvesq^.arvpai := no^.arvpai;
		end;
		dispose(no);
	end;
end;

function ExcluirRaizArvore(var arvraiz:arvore): arvore;
var aux, NovaRaiz : arvore;
begin
	writeln;                                           
	if arvraiz^.arvdir <> nil then
	begin
		NovaRaiz := arvraiz^.arvdir;
		NovaRaiz^.arvpai := nil;
		if arvraiz^.arvesq <> nil then
		begin
			writeln(NovaRaiz^.nome);
			aux := AcharPosicao(NovaRaiz, arvraiz^.arvesq^.nome);
			writeln(aux^.nome);
			aux^.arvesq := arvraiz^.arvesq;
			arvraiz^.arvesq^.arvpai := aux;
		end;
		
	end
	else if arvraiz^.arvesq <> nil then
	begin
		NovaRaiz := arvraiz^.arvesq;
		NovaRaiz^.arvpai := nil;
	end;
	dispose(arvraiz);
	ExcluirRaizArvore := NovaRaiz;	
		
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
var	no_exc, no_exc_cont, estado_exc_pai, arv_exc, estado_exc: arvore;																																							 
begin
	estado_exc := VerificarNoExiste(estado, uf);
	estado_exc_pai := estado_exc^.arvpai;
	if estado_exc^.conteudo = nil then
		no_exc := estado_exc
	else 
		no_exc := VerificarNoExiste(estado_exc^.conteudo, municipio);

	if (no_exc^.arvpai = nil) then //Excluir Raiz
	begin
		writeln('Excluindo a Raiz');
		no_exc_cont := ExcluirRaizArvore(no_exc);
		if no_exc_cont = nil then
		begin
			estado_exc^.conteudo := nil;
			if estado = estado_exc then
				estado := ExcluirRaizArvore(estado)
			else
				ExcluirNo(estado, estado_exc^.nome, 'nada');
		end
		else 
			estado_exc^.conteudo := no_exc_cont;
	end
	else if (no_exc^.arvesq = nil) and (no_exc^.arvdir = nil) then //Excluir folha
		ExcluirFolha(no_exc^.arvpai, no_exc)
	else if no_exc^.arvpai <> nil then
		ExcluirCentral(no_exc^.arvpai, no_exc)
	else
		writeln('Município Inexistente!');

end;

procedure ExibirMenu;
begin
    writeln('0 - Sair');
    writeln('1 - Incluir Estado e Município');
    writeln('2 - Excluir Estado ou Município');
    writeln('3 - Exibir Estados em Ordem');
    writeln('4 - Exibir Estados(Pré-Ordem) e Municípios(Em Ordem)');
		writeln('5 - Contagem de quantos elementos cada UF tem cadastrado');    
end;

Begin  
  IniciarVariaveis(estado);
	opcao := 1;
    
  while opcao <> 0 do
  begin
      clrscr;
      ExibirMenu;       
      readln(opcao); 
      clrscr;
      
      case opcao of

          1: begin
              writeln('Digite a UF: ');
              readln(uf);
              writeln('Digite o município: ');
              readln(municipio);
              IncluirMunicipio(estado, uf, municipio);
              writeln('Estado e município incluídos com sucesso!');
          end;

          2: begin
              writeln('Digite o estado: ');
              readln(uf);
              writeln('Digite o município: ');
              readln(municipio);
              est := VerificarNoExiste(estado, uf);
              if (est <> nil) then
              begin
              	mun := VerificarNoExiste(est^.conteudo, municipio);
              	if (mun <> nil) then
              	begin
              		ExcluirNo(estado, uf, municipio);
              		writeln('Exclusão realizada com sucesso!');
              	end
              	else
              		writeln('O município não existe');
              end
              else
              	writeln('O estado não existe');
          end;
          3: begin
              writeln('Exibindo estados em ordem:');
              EmOrdem(estado);
              writeln;
          end;

          4: begin
              writeln('Exibindo estados(Pré-Ordem) e municípios(Em Ordem):');
              PreOrdem(estado);
              writeln;
          end;
          
          5: begin
            writeln('Contagem de municípios por estado:');
    				ContarMunicipiosPorEstado(estado);       
          end;

          0: writeln('Saindo do programa...');
      else
          writeln('Opção inválida! Tente novamente.');
      end;
      
      {writeln;
      writeln('Pressione Enter para continuar...'); }
      readln;
  end;
End.
