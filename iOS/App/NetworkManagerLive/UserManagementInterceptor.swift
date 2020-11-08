import Apollo
import Foundation

class UserManagementInterceptor: ApolloInterceptor {
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
        
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJhMDRhZjI4Ni00ZWM5LTQzMzYtYmRkMy01MDY4MDNiYjFmNTEifQ.0t_u5vYM_kRpNY03YXMT7S1-Fzn1OGE1EWJbdEnmCnA"
        request.addHeader(name: "Authentication", value: "Bearer: \(token)")
        
        print(request)
        chain.proceedAsync(request: request,
                           response: response,
                           completion: completion)
    }
}
