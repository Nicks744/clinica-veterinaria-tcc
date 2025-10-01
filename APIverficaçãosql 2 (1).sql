CREATE DATABASE IF NOT EXISTS verificar_api;

-- Seleciona o banco de dados
USE verificar_api;

-- Cria a tabela de usuários
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    tipo VARCHAR(50),
    cpf VARCHAR(20)
);

INSERT INTO usuarios (email, senha, tipo, cpf) VALUES
('teste1@email.com', '123456', 'admin', '111.111.111-11'),
('teste2@email.com', 'abcdef', 'usuario', '222.222.222-22'),
('teste3@email.com', 'senha123', 'usuario', '333.333.333-33');

CREATE TABLE verification_codes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    codigo VARCHAR(6) NOT NULL,
    data_criacao DATETIME NOT NULL,
    data_expiracao DATETIME NOT NULL,
    utilizado BOOLEAN DEFAULT FALSE,
    tentativas INT DEFAULT 0,
    ip_solicitacao VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_codigo_length CHECK (LENGTH(codigo) = 6),
    CONSTRAINT chk_email_format CHECK (email LIKE '%@%.%'),
    
    -- Índices
    INDEX idx_email (email),
    INDEX idx_codigo (codigo),
    INDEX idx_expiracao (data_expiracao),
    INDEX idx_email_codigo (email, codigo),
    INDEX idx_utilizado (utilizado),
    INDEX idx_data_criacao (data_criacao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE usuarios_confirmados (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE, -- CAMPO NOVO
    email VARCHAR(255) NOT NULL UNIQUE,
    tipo VARCHAR(50) NOT NULL, -- CAMPO NOVO
    senha VARCHAR(255) NOT NULL,
    idade INT,
    telefone VARCHAR(20),
    endereco TEXT,
    data_confirmacao DATETIME NOT NULL,
    codigo_confirmacao VARCHAR(6),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_cpf (cpf),
    INDEX idx_tipo (tipo)
);

SELECT * FROM usuarios_confirmados;
TRUNCATE TABLE verification_codes;
TRUNCATE TABLE usuarios_confirmados;