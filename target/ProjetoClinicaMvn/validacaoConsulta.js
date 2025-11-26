document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("consulta-form");
    const numero = document.getElementById("numero");
    const rgDono = document.getElementById("rg_dono");

    numero.addEventListener("input", function () {
        formatarNumero(this);
    });

    rgDono.addEventListener("input", function () {
        // Remove tudo que não for número
        this.value = this.value.replace(/\D/g, "").slice(0, 9);
    });

    form.addEventListener("submit", function (event) {
        let erros = [];

        let nome = document.getElementById("nome");
        let dataConsulta = document.getElementById("data_consulta");

        let regexNome = /^[A-Za-zÀ-ÖØ-öø-ÿ\s]+$/;
        let regexNumero = /^\(\d{2}\) \d{5}-\d{4}$/; // Formato correto para telefone
        let regexRG = /^\d{8,9}$/; // Aceita RG com 8 ou 9 números

        limparErros();

        // Validação do Nome
        if (!regexNome.test(nome.value.trim())) {
            erros.push({ campo: "erro-nome", mensagem: "O nome deve conter apenas letras e espaços." });
        }

        // Validação do Número de Celular
        if (!regexNumero.test(numero.value.trim())) {
            erros.push({ campo: "erro-numero", mensagem: "Número inválido! Use o formato (99) 99999-9999." });
        }

        // Validação da Data da Consulta (não pode ser no passado)
        let dataAtual = new Date();
        let dataEscolhida = new Date(dataConsulta.value);
        if (dataEscolhida < dataAtual.setHours(0, 0, 0, 0)) {
            erros.push({ campo: "erro-data", mensagem: "A data da consulta não pode estar no passado." });
        }

        // Se houver erros, exibir e impedir o envio do formulário
        if (erros.length > 0) {
            event.preventDefault();
            mostrarErros(erros);
        }
    });

    function limparErros() {
        document.querySelectorAll(".error-message").forEach(e => e.textContent = "");
    }

    function mostrarErros(erros) {
        erros.forEach(erro => {
            document.getElementById(erro.campo).textContent = erro.mensagem;
        });
    }

    function formatarNumero(input) {
        let numero = input.value.replace(/\D/g, ""); // Remove tudo que não for número

        if (numero.length > 11) numero = numero.slice(0, 11); // Limita a 11 dígitos

        if (numero.length > 2) {
            numero = `(${numero.slice(0, 2)}) ${numero.slice(2)}`;
        }
        if (numero.length > 10) {
            numero = `${numero.slice(0, 10)}-${numero.slice(10)}`;
        }

        input.value = numero;
    }
});
