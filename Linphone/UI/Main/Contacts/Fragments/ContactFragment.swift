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
import Contacts

struct ContactFragment: View {
	
	private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
	
	@ObservedObject var contactViewModel: ContactViewModel
	@ObservedObject var editContactViewModel: EditContactViewModel
	
	@Binding var isShowDeletePopup: Bool
	@Binding var isShowDismissPopup: Bool
	
	@State private var showingSheet = false
	@State private var showShareSheet = false
	
	var body: some View {
		let indexDisplayed = contactViewModel.indexDisplayedFriend != nil ? contactViewModel.indexDisplayedFriend! : 0
		if ContactsManager.shared.avatarListModel.count > indexDisplayed {
			if #available(iOS 16.0, *), idiom != .pad {
				ContactInnerFragment(
					contactAvatarModel: ContactsManager.shared.avatarListModel[indexDisplayed],
					contactViewModel: contactViewModel,
					editContactViewModel: editContactViewModel,
					cnContact: CNContact(),
					isShowDeletePopup: $isShowDeletePopup,
					showingSheet: $showingSheet,
					showShareSheet: $showShareSheet,
					isShowDismissPopup: $isShowDismissPopup
				)
				.sheet(isPresented: $showingSheet) {
					ContactListBottomSheet(contactViewModel: contactViewModel, showingSheet: $showingSheet)
						.presentationDetents([.fraction(0.2)])
				}
				.sheet(isPresented: $showShareSheet) {
					ShareSheet(friendToShare: ContactsManager.shared.lastSearch[contactViewModel.indexDisplayedFriend!].friend!)
						.presentationDetents([.medium])
						.edgesIgnoringSafeArea(.bottom)
				}
			} else {
				ContactInnerFragment(
					contactAvatarModel: ContactsManager.shared.avatarListModel[indexDisplayed],
					contactViewModel: contactViewModel,
					editContactViewModel: editContactViewModel,
					cnContact: CNContact(),
					isShowDeletePopup: $isShowDeletePopup,
					showingSheet: $showingSheet,
					showShareSheet: $showShareSheet,
					isShowDismissPopup: $isShowDismissPopup
				)
				.halfSheet(showSheet: $showingSheet) {
					ContactListBottomSheet(contactViewModel: contactViewModel, showingSheet: $showingSheet)
				} onDismiss: {}
					.sheet(isPresented: $showShareSheet) {
						ShareSheet(friendToShare: ContactsManager.shared.lastSearch[contactViewModel.indexDisplayedFriend!].friend!)
							.edgesIgnoringSafeArea(.bottom)
					}
			}
		}
	}
}

#Preview {
	ContactFragment(
		contactViewModel: ContactViewModel(),
		editContactViewModel: EditContactViewModel(),
		isShowDeletePopup: .constant(false),
		isShowDismissPopup: .constant(false)
	)
}
