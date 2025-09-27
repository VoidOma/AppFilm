// DOSSIER VUE/AddFilmView.swift

import SwiftUI

struct AddFilmView: View {
    // 💡 CORRECT: Reçoit l'objet existant (résout l'erreur de l'argument manquant)
    @ObservedObject var viewModel: FilmViewModel
    
    var isFormValid: Bool {
        !viewModel.titre.isEmpty && Double(viewModel.prix) != nil
    }
    
    var body: some View {
        Form {
            Section(header: Text("Informations du film")) {
                TextField("Titre *", text: $viewModel.titre)
                TextField("Genre", text: $viewModel.genre)
                TextField("Durée (minutes)", text: $viewModel.duree)
                    .keyboardType(.numberPad)
                TextField("Date de sortie (YYYY-MM-DD)", text: $viewModel.dateSortie)
                TextField("Prix *", text: $viewModel.prix)
                    .keyboardType(.decimalPad)
                TextField("Réalisateur", text: $viewModel.realisateur)
            }
            
            Button(action: {
                Task { await viewModel.addFilm() }
            }) {
                Text("Ajouter le film")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isFormValid)
            
            if !viewModel.statusMessage.isEmpty {
                Text(viewModel.statusMessage)
                    .foregroundColor(viewModel.statusMessage.contains("✅") ? .green : .red)
            }
        }
        .navigationTitle("Ajouter un film")
    }
}
