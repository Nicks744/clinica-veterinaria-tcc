package br.com.clinica.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import java.util.Scanner;

/**
 * Uma classe utilitária simples para gerar hashes de senha BCrypt.
 * Execute este ficheiro para criar uma nova senha encriptada para colocar na sua base de dados.
 */
public class GeradorDeHash {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

        System.out.println("--- Gerador de Hash de Senha BCrypt ---");
        System.out.print("Digite a senha que deseja encriptar (ex: admin123): ");

        // Lê a senha que você digitar no console
        String senhaEmTextoPlano = scanner.nextLine();

        // Gera o hash encriptado
        String senhaHasheada = passwordEncoder.encode(senhaEmTextoPlano);

        System.out.println("\nSenha original: " + senhaEmTextoPlano);
        System.out.println("HASH GERADO (copie esta linha para a sua base de dados):");
        System.out.println(senhaHasheada);

        scanner.close();
    }
}

