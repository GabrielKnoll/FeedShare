import Apollo
import Foundation

class UserManagementInterceptor: ApolloInterceptor {
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) {
        if let viewer = ViewerModel.shared.viewer {
            request.addHeader(name: "Authorization", value: "Bearer \(viewer.token)")
        }

        chain.proceedAsync(request: request,
                           response: response,
                           completion: completion)
    }
}
