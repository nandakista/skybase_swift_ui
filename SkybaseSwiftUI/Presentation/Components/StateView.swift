//
//  StateView.swift
//  SkybaseSwiftUI
//
//  Created by Nanda Kista Permana on 28/10/24.
//

import SwiftUI

struct StateView<Content: View, LoadingView: View, ErrorView: View, EmptyView: View>: View {
    let isLoading: Bool
    var isEmpty: Bool = false
    var isError: Bool = false
    let errorMessage: String?
    let loadingContent: LoadingView
    var emptyContent: EmptyView
    let errorContent: (String) -> ErrorView
    let content:  Content

    init(
        loadingWhen: Bool,
        emptyWhen: Bool = false,
        errorWhen: Bool = false,
        errorMessage: String? = nil,
        @ViewBuilder loadingView: () -> LoadingView = { ProgressView() },
        @ViewBuilder emptyView: () -> EmptyView = { Text("No content available") },
        @ViewBuilder errorView: @escaping (String) -> ErrorView = { error in
            Text(error).foregroundColor(.red)
        },
        @ViewBuilder content: () -> Content
    ) {
        self.isLoading = loadingWhen
        self.isEmpty = emptyWhen
        self.isError = errorWhen
        self.errorMessage = errorMessage
        self.loadingContent = loadingView()
        self.errorContent = errorView
        self.emptyContent = emptyView()
        self.content = content()
    }

    var body: some View {
        if isLoading {
            loadingContent
                .navigationBarTitleDisplayMode(.inline)
        } else if isError && errorMessage != nil {
            errorContent(errorMessage ?? "An error occurred")
        } else if isEmpty {
            emptyContent
        } else {
            content
        }
    }
}
