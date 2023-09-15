-- Efetuar as seguintes consultas sobre os dados inseridos:

-- a - Dados completos de pessoas físicas.
SELECT  Pessoa,*,  PessoaFisica.cpf  
FROM Pessoa 
INNER JOIN PessoaFisica 
    ON Pessoa.idPessoa = PessoaFisica.Pessoa_idPessoa 
WHERE idpessoa = Pessoa_idPessoa

-- b - Dados completos de pessoas jurídicas.
SELECT Pessoa,*,  PessoaJuridica.cnpj 
FROM Pessoa
INNER JOIN  PessoaJuridica 
    ON Pessoa.idPessoa = PessoaJuridica.Pessoa_idPessoa
WHERE idPessoa = Pessoa_idPessoa


-- c - Movimentações de entrada, com produto, fornecedor, quantidade, preço unitário e valor total
SELECT Produto.nome as produto,
	Pessoa.nome as fornecedor,
    Movimento.quantidade,
    Movimento.valorUnitario,
    (Movimento.quantidade * Movimento.valorUnitario) AS valor_total
FROM Movimento
INNER JOIN Pessoa 
    ON Movimento.Pessoa_idPessoa = Pessoa.idPessoa
INNER JOIN Produto 
    ON Movimento.Produto_idProduto = Produto.idProduto
WHERE Movimento.tipo = 'E';


-- d - Movimentações de saída, com produto, comprador, quantidade, preço unitário e valor total.
SELECT Produto.nome AS produto,
	Pessoa.nome AS comprador,
    Movimento.quantidade,
    Movimento.valorUnitario,
    (Movimento.quantidade * Movimento.valorUnitario) AS valor_total
FROM Movimento
INNER JOIN Pessoa 
    ON Movimento.Pessoa_idPessoa = Pessoa.idPessoa
INNER JOIN	Produto 
    ON Movimento.Produto_idProduto = Produto.idProduto
WHERE Movimento.tipo = 'S';

-- e - Valor total das entradas agrupadas por produto.
SELECT SUM(Movimento.quantidade * Movimento.valorUnitario) as valor_total, Produto.nome as produto
FROM Movimento
INNER JOIN Produto ON Movimento.Produto_idProduto = Produto.idProduto
WHERE Movimento.tipo = 'E'
GROUP BY Produto.idProduto


-- e - Valor total das saídas agrupadas por produto.
SELECT SUM(Movimento.quantidade * Movimento.valorUnitario) as valor_total, Produto.nome as produto
FROM Movimento
INNER JOIN Produto ON Movimento.Produto_idProduto = Produto.idProduto
WHERE Movimento.tipo = 'S'
GROUP BY Produto.idProduto


-- g - Operadores que não efetuaram movimentações de entrada (compra).
SELECT Usuario.login AS operador
FROM Usuario
WHERE NOT EXISTS (
    SELECT 1
    FROM Movimento
    WHERE Movimento.Usuario_idUsuario = Usuario.idUsuario
    AND Movimento.tipo = 'E'
);


-- h - Valor total de entrada, agrupado por operador.
SELECT SUM(Movimento.quantidade * Movimento.valorUnitario) AS valor_total, Usuario.login AS operador
FROM Movimento
INNER JOIN Usuario 
    ON Movimento.Usuario_idUsuario = Usuario.idUsuario
WHERE Movimento.tipo = 'E'
GROUP BY Usuario.idUsuario


-- i - Valor total de saída, agrupado por operador.
SELECT SUM(Movimento.quantidade * Movimento.valorUnitario) AS valor_total, Usuario.login AS operador
FROM Movimento
INNER JOIN Usuario  
    ON Movimento.Usuario_idUsuario = Usuario.idUsuario
WHERE Movimento.tipo = 'S'
GROUP BY Usuario.idUsuario


-- j -Valor médio de venda por produto, utilizando média ponderada.
SELECT SUM(Movimento.quantidade * Movimento.valorUnitario)/SUM(Movimento.quantidade) AS media_ponderada, Produto.nome AS produto
FROM Movimento AS mov
INNER JOIN Produto AS pro ON Movimento.Produto_idProduto = Produto.idProduto
WHERE Movimento.tipo = 'S'
GROUP BY Produto.nome
