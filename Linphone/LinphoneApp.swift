/*
 * Copyright (c) 2010-2023 Belledonne Communications SARL.
 *
 * This file is part of linphone-iphone
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import SwiftUI

@main
struct LinphoneApp: App {
	
	@ObservedObject private var coreContext = CoreContext.shared
	@ObservedObject private var sharedMainViewModel = SharedMainViewModel()
	
	@State private var isActive = false
	
	var body: some Scene {
		WindowGroup {
			if isActive {
				if !sharedMainViewModel.welcomeViewDisplayed {
					WelcomeView(sharedMainViewModel: sharedMainViewModel)
				} else if coreContext.defaultAccount == nil || sharedMainViewModel.displayProfileMode {
					AssistantView(sharedMainViewModel: sharedMainViewModel)
						.toast(isShowing: $coreContext.toastMessage)
				} else if coreContext.defaultAccount != nil {
					ContentView(contactViewModel: ContactViewModel(), historyViewModel: HistoryViewModel())
						.toast(isShowing: $coreContext.toastMessage)
				}
			} else {
				SplashScreen(isActive: $isActive)
			}
		}
	}
}
