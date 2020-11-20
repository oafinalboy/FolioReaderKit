//
//  FolioReaderScript.swift
//  FolioReaderKit
//
//  Created by Stanislav on 12.06.2020.
//  Copyright (c) 2015 Folio Reader. All rights reserved.
//

import WebKit

class FolioReaderScript {
        
    static func bridgeJS() -> WKUserScript {
        let jsURL = Bundle.frameworkBundle().url(forResource: "Bridge", withExtension: "js")!
        let jsSource = try! String(contentsOf: jsURL)
        return WKUserScript(source: jsSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
    
    static func cssInjection() -> WKUserScript {
        let cssURL = Bundle.frameworkBundle().url(forResource: "Style", withExtension: "css")!
        let cssString = try! String(contentsOf: cssURL)
        return WKUserScript(source: cssInjectionSource(for: cssString), injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
    
    static func cssInjection(overflow: String) -> WKUserScript {
        let cssString = "html{overflow:\(overflow)}"
        return WKUserScript(source: cssInjectionSource(for: cssString), injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
    
    private static func cssInjectionSource(for content: String) -> String {
        let oneLineContent = content.components(separatedBy: .newlines).joined()
        let source = """
        var style = document.createElement('style');
        style.type = 'text/css'
        style.innerHTML = '\(oneLineContent)';
        document.head.appendChild(style);
        """
        return source
    }
    
}

extension WKUserScript {
    
    func addIfNeeded(to webView: WKWebView?) {
        guard let controller = webView?.configuration.userContentController else { return }
        let alreadyAdded = controller.userScripts.contains { [unowned self] in
            return $0.source == self.source &&
                $0.injectionTime == self.injectionTime &&
                $0.isForMainFrameOnly == self.isForMainFrameOnly
        }
        if alreadyAdded { return }
        controller.addUserScript(self)
    }
    
}
