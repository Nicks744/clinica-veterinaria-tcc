  function abrirModal(nome, numero, cpf, data, genero, raca, sintomas, peso, obs, status, data_marcada) {
        document.getElementById("modal-nome").innerText = nome;
        document.getElementById("modal-numero").innerText = numero;
        document.getElementById("modal-cpf").innerText = cpf;
        document.getElementById("modal-genero").innerText = genero;
        document.getElementById("modal-raca").innerText = raca;
        document.getElementById("modal-peso").innerText = peso;
        document.getElementById("modal-sintomas").innerText = sintomas;
        document.getElementById("modal-data").innerText = data;
        document.getElementById("modal-data-marcada").innerText = data_marcada;
        document.getElementById("modal-status").innerText = status;
        document.getElementById("modal-obs").innerText = obs;

        document.getElementById("modal").style.display = "block";
    }

    function fecharModal() {
        document.getElementById("modal").style.display = "none";
    }

    function limparCampo(id) {
        const input = document.getElementById(id);
        input.value = '';
        input.focus();
        input.dispatchEvent(new Event('input'));
    }

    window.onclick = function(event) {
        var modal = document.getElementById("modal");
        if (event.target === modal) {
            fecharModal();
        }
    }

    document.addEventListener("DOMContentLoaded", function () {
        const input = document.getElementById("buscaNomeCpf");
        const clearBtn = input.nextElementSibling;

        input.addEventListener("input", function () {
            clearBtn.style.display = input.value ? "block" : "none";
        });

        clearBtn.style.display = input.value ? "block" : "none";
    });
    
    function buscarAutomaticamente() {
    const status = document.getElementById("status").value;
    const buscaNomeCpf = document.getElementById("buscaNomeCpf").value;

    const xhr = new XMLHttpRequest();
    xhr.open("GET", `listarConsulta.jsp?status=${encodeURIComponent(status)}&buscaNomeCpf=${encodeURIComponent(buscaNomeCpf)}`, true);
    xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");

    xhr.onload = function () {
        if (xhr.status === 200) {
            const parser = new DOMParser();
            const doc = parser.parseFromString(xhr.responseText, "text/html");
            const novosCards = doc.querySelector(".card-container");
            document.querySelector(".card-container").innerHTML = novosCards.innerHTML;
        }
    };

    xhr.send();
}

function limparCampo(idCampo) {
    document.getElementById(idCampo).value = "";
    buscarAutomaticamente();
}

// Ativa a busca automática ao mudar o status também
window.addEventListener("DOMContentLoaded", () => {
    document.getElementById("status").addEventListener("change", buscarAutomaticamente);
    document.getElementById("buscaNomeCpf").addEventListener("input", buscarAutomaticamente);
});