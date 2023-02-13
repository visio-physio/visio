//
//  ServerConnectionTest.swift
//  Viso
//
//  Created by Vector Wu on 2023-02-10.
//

import SwiftUI

struct ServerConnectionTest: View {
    @EnvironmentObject var client: VisioClient

    
    var body: some View {
        let flag = client.start()
        Text(flag)
    }
}

struct ServerConnectionTest_Previews: PreviewProvider {
    static var previews: some View {
        ServerConnectionTest()
            .environmentObject(VisioClient(host: "127.0.0.1", port: 8888, delegate: nil))

    }
}
