#pragma D option quiet
pid$target::objc_msgSend:entry
/arg0 != 0/
{
    isaptr = *(uint32_t*) copyin(arg0, 4);
    classnameptr = *(uint32_t*) copyin(isaptr + 8, 4);
    classname = copyinstr(classnameptr);

    printf("[%s %s]\n", classname, copyinstr(arg1));
}
