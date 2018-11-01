grammar =
[
S = [ [[:TYPE,ID, :PARAM, O_C_BRCKT, :ALL_INTER, C_C_BRCKT]], Int(S_)],

    TYPE = [ [[IDT_INT],
              [IDT_CHAR],
              [IDT_FLOAT],
              [IDT_STRING]], Int(TYPE_)],

    PARAM = [ [[O_BRCKT, C_BRCKT],
               [O_BRCKT, :P1, C_BRCKT]], Int(PARAM_)],
    P1 = [ [[:TYPE, :IDVEC],
            [:TYPE, :IDVEC, COMMA, :P1]], Int(P1_)],


    #=
    EXPR_STR -> EXPR_STR + EXPR_STR | CT_STR | IDVEC
    =#
    EXS2 = [[[:IDVEC],
             [CT_STR]], Int(EXS2_)],
    EXS1 = [[[OPR_PM,:EXS2, :EXS1],
             [EPS]], Int(EXS1_)],
    EXPR_STR =[[[:EXS2, :EXS1]], Int(EXPR_STR_)],



    IDVEC = [[[ID],
              [ID, VEC_IN, :EXPR_I_F]], Int(IDVEC_)],
    ATTR = [[[:TYPE, :IDVEC, EQ, :EXPR_I_F],
             [:TYPE, :IDVEC, EQ, EXPR_STR]], Int(ATTR_)],


    EXPR_ALL = [[[:EXPR_I_F], [:EXPR_STR], [:EXPR_BOOL]], Int(EXPR_ALL_)],

    EXPR_I_F =[[[:EX1],
                [:EX1, OPR_PM ,:EXPR_I_F]], Int(EXPR_I_F_)],
    EX1 = [[[:EX2,:EX11]], Int(EX1_)],
    EX11 = [[[OPR_DM,:EX2, :EX11],
             [EPS]], Int(EX11_)],
    EX2 = [[[:IDVEC],
            [CT_FLOAT],
            [CT_INT],
            [O_BRCKT, :EX2, C_BRCKT]], Int(EX2_)],


    EXPR_BOOL = [[[:EXB1],
                  [:EXB1, OPRLR_OR, :EXPR_BOOL]], Int(EXPR_BOOL_)],
    EXB1 = [[[:EXB1, :EXB11]], Int(EXB1_)],
    EXB11 = [[[OPRLR_AND, :EXB2, :EXB11],
              [EPS]], Int(EXB11_)],
    EXB2 = [[[:IDVEC],
             [C_BRCKT, :EXPR_BOOL, C_BRCKT] ,
             [CT_INT]], Int(EXB2_)],

    ALL_INTER = [[[:RIF, :ALL_INTER],
                  [ATTR , :ALL_INTER],
                  [:RWHILE, :ALL_INTER],
                  [:RFOR, :ALL_INTER],
                  [:RCONT, :ALL_INTER]],Int(ALL_INTER_)],

    RIF = [[[BLK_IF, O_BRCKT, :EXPR_BOOL, C_BRCKT,
             O_C_BRCKT, :ALL_INTER,C_C_BRCKT, :RIF1]], Int(RIF_)],
    RIF1 = [[[BLK_ELSE, :RIF1],
             [BLK_ELSE, O_C_BRCKT, :ALL_INTER, C_C_BRCKT], [EPS]],
            Int(RIF1_)],

    RWHILE = [[[BLK_WHILE, O_BRCKT, :EXPR_BOOL, O_BRCKT, O_C_BRCKT, :ALL_INTER, C_C_BRCKT]], Int(RWHILE_)],

    RFOR = [[[BLK_FOR, O_BRCKT, ATTR, COMMA,:EXPR_I_F, COMMA, :EXPR_I_F,
              C_BRCKT, O_C_BRCKT, :ALL_INTER, C_C_BRCKT]], Int(RFOR_)],

    RCONT = [[[CONTINUE], [BREAK], [RETURN], [RETURN, EXPR_ALL]], Int(RCONT_)],
]
