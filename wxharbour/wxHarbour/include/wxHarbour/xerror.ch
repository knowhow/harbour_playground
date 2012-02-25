/*
 * $Id: xerror.ch 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    xerror.ch - eXtended error manager
    Teo. Mexico 2007
*/

#ifndef __XERROR_CH__
#define __XERROR_CH__
/* THROW => generate error */
#xtranslate THROW(<oErr>) => (Eval(ErrorBlock(), <oErr>), Break(<oErr>))

#xcommand RAISE ERROR <cDescription> ;
                                        [ SUBSYSTEM <cSubsystem> ] ;
                                        [ OPERATION <cOperation> ] ;
                                        [ ARGS <aArgs> ] ;
                    => ;
                    Throw( MyErrorNew( [<cSubsystem>], ;
                                                         [<cOperation>], ;
                                                            <cDescription>, ;
                                                         [<aArgs>], ;
                                                            ProcFile(), ;
                                                            ProcName(), ;
                                                            ProcLine() ;
                                                        ) ;
                                )

#xcommand SHOW ERROR <errObj> ;
                    => ;
            wxhShowError( "", { wxhLABEL_ACCEPT }, <errObj> )
#endif
