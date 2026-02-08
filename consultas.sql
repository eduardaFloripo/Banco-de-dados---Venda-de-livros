/*
-- Para esta consulta, nosso objetivo foi contar quantos clientes temos em cada região. Para isso, percebemos que a 
-- informação da região estava na tabela ESTADO e a do cliente na CLIENTE. Tivemos que juntar quatro tabelas 
-- (CLIENTE -> ENDERECO -> CIDADE -> ESTADO) para conseguir conectar as duas pontas.
-- Usamos COUNT(DISTINCT ...) para não correr o risco de contar o mesmo cliente mais de uma vez, caso ele tivesse 
-- vários endereços, e o GROUP BY para agrupar o resultado por região.
*/
SELECT
    ES.regiao AS "Região",
    COUNT(DISTINCT CL.cod_cliente) AS "Quantidade de Clientes"
FROM
    CLIENTE CL
    JOIN ENDERECO E ON CL.cod_cliente = E.cod_cliente
    JOIN CIDADE C ON E.cod_cidade = C.cod_cidade
    JOIN ESTADO ES ON C.uf = ES.uf
GROUP BY
    ES.regiao
ORDER BY
    "Quantidade de Clientes" DESC;


/*
-- Aqui, nossa meta era descobrir os 10 produtos mais populares. Vimos que a quantidade vendida de cada um estava 
-- na tabela ITEM_PEDIDO e o nome na tabela PRODUTO, então fizemos um JOIN entre as duas para conectar as informações.
-- Usamos a função SUM() para somar o total de unidades vendidas e o GROUP BY para que a soma fosse feita para cada
-- produto individualmente. Para pegar só os 10 primeiros, ordenamos o resultado com ORDER BY ... DESC e aplicamos
-- o comando FETCH FIRST 10 ROWS ONLY.
*/
SELECT
    P.nome AS "Produto",
    SUM(IP.quantidade) AS "Total Vendido"
FROM
    ITEM_PEDIDO IP
    JOIN PRODUTO P ON IP.cod_produto = P.cod_produto
GROUP BY
    P.nome
ORDER BY
    "Total Vendido" DESC
FETCH FIRST 10 ROWS ONLY;


/*
-- Neste caso, queríamos listar os 5 pedidos mais caros e quem os vendeu. O primeiro passo foi calcular o valor total
-- de cada pedido, o que fizemos multiplicando a quantidade (da tabela ITEM_PEDIDO) pelo preço (da tabela PRODUTO).
-- Para pegar o nome do funcionário, tivemos que juntar a tabela PEDIDO com a FUNCIONARIO. Optamos por usar um
-- LEFT JOIN, pois isso garante que pedidos sem um vendedor registrado ainda apareçam na lista. No final,
-- agrupamos por pedido, ordenamos pelo valor total e limitamos o resultado aos 5 maiores.
*/
SELECT
    PE.num_pedido AS "Número do Pedido",
    F.nome AS "Funcionário",
    TO_CHAR(SUM(IP.quantidade * P.preco), 'L999G999D99') AS "Valor Total"
FROM
    ITEM_PEDIDO IP
    JOIN PRODUTO P ON IP.cod_produto = P.cod_produto
    JOIN PEDIDO PE ON IP.num_pedido = PE.num_pedido
    LEFT JOIN FUNCIONARIO F ON PE.matricula_func = F.matricula
GROUP BY
    PE.num_pedido, F.nome
ORDER BY
    SUM(IP.quantidade * P.preco) DESC
FETCH FIRST 5 ROWS ONLY;

/*
-- Para esta consulta, nosso desafio era listar as categorias principais (aquelas que não são subcategorias) e contar 
-- quantos produtos cada uma possui. Primeiro, filtramos a tabela CATEGORIA com a condição WHERE cod_categoria_pai IS NULL.
-- Depois, decidimos usar um LEFT JOIN com a tabela PRODUTO. Essa abordagem foi importante para garantir que mesmo as 
-- categorias que não tivessem nenhum produto associado fossem exibidas no resultado, com a contagem zerada.
*/
SELECT
    C.nome AS "Categoria Principal",
    COUNT(P.cod_produto) AS "Quantidade de Produtos"
FROM
    CATEGORIA C
    LEFT JOIN PRODUTO P ON C.cod_categoria = P.cod_categoria
WHERE
    C.cod_categoria_pai IS NULL
GROUP BY
    C.nome
ORDER BY
    "Quantidade de Produtos" DESC;


/*
-- Aqui, a ideia era criar uma lista de produtos e quais fornecedores os oferecem, mas mostrando apenas os que estivessem
-- disponíveis. Para fazer a ligação entre PRODUTO e FORNECEDOR, que têm uma relação N:N, usamos a tabela associativa
-- PRODUTO_FORNECEDOR. O filtro com WHERE disponibilidade = 'D' foi a chave para trazer apenas as relações ativas,
-- como pedia o enunciado.
*/
SELECT
    P.nome AS "Produto",
    F.nome AS "Fornecedor"
FROM
    PRODUTO P
    JOIN PRODUTO_FORNECEDOR PF ON P.cod_produto = PF.cod_produto
    JOIN FORNECEDOR F ON PF.cod_fornecedor = F.cod_fornecedor
WHERE
    PF.disponibilidade = 'D'
ORDER BY
    P.nome, F.nome;   


/*
-- Para montar o relatório de entregas, nosso ponto de partida foi a tabela ENTREGA. Para enriquecer o relatório
-- com informações úteis, fizemos JOIN com a tabela ENDERECO (para pegar a rua e o número), com a CLIENTE (para pegar
-- o nome do cliente) e com a CIDADE (para exibir o nome da cidade e a UF). Por fim, ordenamos tudo pela data da
-- entrega para que o relatório ficasse em ordem cronológica.
*/
SELECT
    EN.data AS "Data da Entrega",
    CL.nome AS "Cliente",
    E.rua || ', ' || E.numero || ' - ' || C.nome || '/' || C.uf AS "Endereço Completo",
    EN.mot_nome AS "Nome do Motorista"
FROM
    ENTREGA EN
    JOIN ENDERECO E ON EN.cod_endereco = E.cod_endereco
    JOIN CLIENTE CL ON E.cod_cliente = CL.cod_cliente
    JOIN CIDADE C ON E.cod_cidade = C.cod_cidade
ORDER BY
    EN.data;



/*
-- Nesta consulta extra que construímos, nosso objetivo foi descobrir quais dos nossos funcionários venderam para clientes
-- do tipo "Pessoa Jurídica". A lógica foi conectar a tabela FUNCIONARIO com a CLIENTE, usando a tabela PEDIDO como ponte.
-- O comando WHERE C.tipo = 'J' foi usado para filtrar apenas os clientes que são empresas. Além disso, usamos DISTINCT
-- para garantir que o nome de cada vendedor aparecesse somente uma vez no resultado, mesmo que ele tivesse feito várias vendas.
*/
SELECT DISTINCT
    F.nome AS "Funcionário",
    F.email AS "Email"
FROM
    FUNCIONARIO F
    JOIN PEDIDO P ON F.matricula = P.matricula_func
    JOIN CLIENTE C ON P.cod_cliente = C.cod_cliente
WHERE
    C.tipo = 'J'
ORDER BY
    F.nome;