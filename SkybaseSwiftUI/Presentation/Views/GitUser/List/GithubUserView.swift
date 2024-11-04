//
//  GithubUserView.swift
//  SkybaseSwiftUI
//
//  Created by Nanda Kista Permana on 26/10/23.
//

import SwiftUI

struct GithubUserView: View {
    @Binding var selectedTab: Int
    @StateObject private var viewModel = GithubUserViewModel(dataSource: GithubDataSource())
    
    var body: some View {
        StateView(
            loadingWhen: viewModel.isLoading,
            emptyWhen: viewModel.isEmpty,
            errorWhen: viewModel.isError,
            errorMessage: viewModel.errorMessage,
            content: {
                List {
                    ForEach(viewModel.dataList) { githubUser in
                        NavigationLink(value: githubUser) {
                            GitUserItemList(githubUser: githubUser)
                        }
                        .onAppear {
                            if (githubUser == viewModel.dataList.last) {
                                viewModel.onLoadNext()
                            }
                        }
                    }
                    
                    if viewModel.isLoadingNext {
                        HStack {
                            ProgressView()
                            Text("Loading...")
                        }
                    }
                    
                    if viewModel.isErrorNext {
                        Text("Tap to try again")
                            .onTapGesture {
                                viewModel.onLoadNext()
                            }
                    }
                }
                .navigationDestination(for: GithubUser.self, destination: { githubUser in
                    GithubUserDetailView(
                        username: githubUser.username ?? ""
                    ).toolbar(.hidden, for: .tabBar)
                })
                .listStyle(.plain)
                .navigationTitle("Github Users")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    selectedTab = 1
                                }
                            Image(systemName: "gear")
                                .foregroundColor(.black)
                                .onTapGesture {
                                    // TODO: Handle gear icon tap
                                }
                        }
                    }
                }
            }
        )
    }
}

struct GithubUserView_Previews: PreviewProvider {
    static var previews: some View {
        @State var selectedTab: Int = 0
        
        NavigationStack {
            GithubUserView(selectedTab: $selectedTab)
        }
    }
}
