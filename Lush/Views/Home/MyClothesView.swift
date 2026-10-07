//
//  MyClothesView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 02/10/26.
//

import SwiftUI
import SwiftData

struct MyClothesView: View {

    @Environment(\.dismiss) private var dismiss

    @Query private var users: [UserModel]

    @State private var showAddClothing = false
    @State private var selectedCloth: ClothesModel?
    @State private var searchText = ""

    var currentUser: UserModel? {
        users.first
    }

    private var filteredClothes: [ClothesModel] {
        let clothes = currentUser?.userClothes ?? []

        let text = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        if text.isEmpty {
            return clothes
        }

        return clothes.filter { cloth in
            cloth.name.localizedCaseInsensitiveContains(text)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {


                ScreenHeader(
                    title: "Minhas roupas",
                    subtitle: "Adicione suas roupas e faça escolhas assertivas"
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 8)


                HStack(spacing: 10) {

                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color("titles"))

                    TextField(
                        "Buscar minhas roupas",
                        text: $searchText
                    )
                    .font(.system(size: 17))
                    .foregroundStyle(.quartenary)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 17))
                                .foregroundStyle(
                                    Color("titles").opacity(0.45)
                                )
                        }
                        .buttonStyle(.plain)
                    }

                    Image(systemName: "mic.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color("titles"))
                }
                .padding(.horizontal, 17)
                .frame(height: 48)
                .background {
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .overlay {
                            Capsule().fill(.white.opacity(0.20))
                        }
                }
                .overlay {
                    Capsule()
                        .stroke(.white.opacity(0.65),lineWidth: 0.7)
                }
                .shadow(color: .black.opacity(0.06),radius: 8,y: 3)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)


                if searchText
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .isEmpty {

                    categoriesView

                } else {

                    searchResultsView
                }
            }
            .padding(.bottom, 20)
        }
        .scrollIndicators(.hidden)
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }


        .toolbar {
            Toolbar(action: .add,onBackClick: { dismiss() }, onActionClick: { showAddClothing = true })
        }
        .navigationBarBackButtonHidden(true)


        .navigationDestination(item: $selectedCloth) { cloth in
            ClothingDetailView(clothingItem: cloth)
        }


        .fullScreenCover(isPresented: $showAddClothing) {
            NavigationStack {
                AddClothingView()
            }
        }
    }


    private var categoriesView: some View {

        let categoriesToDisplay: [
            (title: String,categories: [GarmentCategory])] = [

            ("Camisas",
                [   .tShirt,
                    .tankTop,
                    .croppedTop,
                    .blouse,
                    .shirt,
                    .bodysuit,
                    .sweater
                ]
            ),

            ("Calças",
                [   .pants,
                    .shorts,
                    .leggings,
                    .bermudaShorts
                ]
            ),

            ("Saias", [.skirt]),

            ("Vestidos",
                [   .dress,
                    .jumpsuit
                ]
            )
        ]

        let userClothes = currentUser?.userClothes ?? []

        return ForEach(
            categoriesToDisplay,
            id: \.title
        ) { group in

            let clothes = userClothes.filter {
                group.categories.contains($0.garmentCategory)
            }

            let photos: [UIImage?] = clothes.map { cloth in
                if let data = cloth.photo {
                    return UIImage(data: data)
                }

                return nil
            }

            ClothesCategorySection(
                title: group.title,
                photos: photos.isEmpty
                    ? [nil, nil, nil, nil]
                    : photos,
                onSeeAllClick: {
                },
                onItemClick: { index in

                    if index < clothes.count {
                        selectedCloth = clothes[index]
                    }
                }
            )
        }
    }


    private var searchResultsView: some View {

        VStack(alignment: .leading, spacing: 12) {

            if filteredClothes.isEmpty {

                VStack(spacing: 12) {

                    Image(systemName: "hanger")
                        .font(.system(size: 36))
                        .foregroundStyle(Color("titles"))

                    Text("Nenhuma roupa encontrada.")
                        .font(.AppTypography.body)
                        .foregroundStyle(Color("titles"))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 40)

            } else {

                ForEach(filteredClothes) { cloth in

                    Button {
                        selectedCloth = cloth
                    } label: {

                        HStack(spacing: 16) {

                            if let data = cloth.photo,
                               let image = UIImage(data: data) {

                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80,height: 90)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))

                            } else {

                                Image(systemName: "hanger")
                                    .font(.title2)
                                    .frame(width: 80,height: 90)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }

                            VStack(alignment: .leading,spacing: 6) {

                                Text(cloth.name)
                                    .font(.AppTypography.title3)
                                    .foregroundStyle(Color("titles"))

                                Text(cloth.garmentCategory.rawValue)
                                .font(.AppTypography.body)
                                .foregroundStyle(Color("titles").opacity(0.7))
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                            .foregroundStyle(Color("titles"))
                        }
                        .padding(12)
                        .background(.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                            .stroke(Color("borderLines"),lineWidth: 0.5)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    NavigationStack {
        MyClothesView()
    }
}
