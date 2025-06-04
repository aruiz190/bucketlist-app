import SwiftUI

struct BucketListView: View {
    @EnvironmentObject var vm: BucketListViewModel
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                if let user = authVM.user {
                    mainView(userID: user.uid)
                } else {
                    AuthView()
                }
            }
            .navigationTitle("My Bucket List")
        }
        .onAppear {
            vm.fetchLists()
        }
    }

    @ViewBuilder
    private func mainView(userID: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("Select List", selection: $vm.currentList) {
                ForEach(vm.lists, id: \.id) { list in
                    Text(list.title).tag(Optional(list))
                }
            }

            HStack {
                TextField("New List Title", text: $vm.newListTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Create List") {
                    vm.createNewList()
                }
            }

            HStack {
                TextField("New item...", text: $vm.newItemTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: vm.addItem) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
                .disabled(vm.newItemTitle.isEmpty || vm.currentList == nil)
            }

            List(vm.items) { item in
                HStack {
                    if let url = URL(string: item.imageURL ?? "") {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }

                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.headline)
                        Text("Created: \(item.timestamp.formatted())")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }

            Button("Sign Out") {
                authVM.signOut()
            }
            .foregroundColor(.red)
            .padding(.top)
        }
        .padding()
    }
}

