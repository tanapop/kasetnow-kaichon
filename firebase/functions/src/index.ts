import * as admin from 'firebase-admin'

admin.initializeApp()
admin.firestore().settings({ ignoreUndefinedProperties: true })

import { handleChatMsg } from './chat_msg'
import { handleGroupMsg } from './group_msg'
import { editProfile } from './profile_edit'
import { banUser } from './ban_user'
import { onEmailSignup } from './on_signup'
import { checkuser } from './newapi/checkuser'
import { auth } from './newapi/auth'
import { getallevent } from './newapi/getallevent'
import { UpdateChannelId } from './newapi/updateliveid'
import { geteventbyid } from './newapi/geteventbyid'
import { getqrcheck } from './newapi/getqrcheck'


export {
    handleChatMsg,
    handleGroupMsg,
    editProfile,
    banUser,
    onEmailSignup,
    checkuser,
    auth,
    getallevent,
    UpdateChannelId,
    geteventbyid,
    getqrcheck
}
