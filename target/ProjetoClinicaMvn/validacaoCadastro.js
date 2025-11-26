document.addEventListener("DOMContentLoaded", function () {
    document.getElementById("cadastro-form").addEventListener("submit", function (event) {
        let senha = document.getElementById("senhaUsuario").value;
        let confirmarSenha = document.getElementById("confirm-password").value;
        let erroSenha = document.getElementById("erro-senha");
        let erroConfirmarSenha = document.getElementById("erro-confirmar-senha");
        const rgDono = document.getElementById("rg_dono"); 
        const erroRG = document.getElementById("erro-rg"); 

        // Resetando mensagens de erro
        erroSenha.innerHTML = "";
        erroConfirmarSenha.textContent = "";
        erroRG.textContent = "";

       
        // Verificação de senha
        if (senha.length < 8) erros.push("A senha deve ter pelo menos 8 caracteres.");
        if (!/[A-Z]/.test(senha)) erros.push("A senha deve conter pelo menos uma letra maiúscula.");
        if (!/\d/.test(senha)) erros.push("A senha deve conter pelo menos um número.");
        if (!/[\W_]/.test(senha)) erros.push("A senha deve conter pelo menos um caractere especial.");

        if (erros.length > 0) {
            erros.forEach(erro => {
                let li = document.createElement("li");
                li.textContent = erro;
                erroSenha.appendChild(li);
            });
            erroSenha.style.display = "block";
            formValido = false;
        }

        if (senha !== confirmarSenha) {
            erroConfirmarSenha.textContent = "As senhas não correspondem.";
            erroConfirmarSenha.style.display = "block";
            formValido = false;
        }

        if (!formValido) {
            event.preventDefault();
        }
    });
});
