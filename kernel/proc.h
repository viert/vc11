#ifndef __KERNEL_H__
#define __KERNEL_H__

#define PROCS_TABLE_ADDR		0x8400
#define PROCS_CURRENT_ADDR		0x83FF
#define	MAX_PROCESSES			8

typedef struct {
	unsigned int	code_start;
	unsigned int	code_size; // unused
	unsigned int	stack_pointer;
	unsigned char	exists;
	enum 			{S_RUNNING, S_STOPPED} status;
} p_descriptor_t;

extern p_descriptor_t*					find_empty_slot();
extern p_descriptor_t*					create_process(void* code_start, void* stack_start);
extern p_descriptor_t* __FASTCALL__ 	get_process_descriptor(unsigned char p_num);
extern p_descriptor_t*					get_process_descriptor_current();
extern void								reap_process();
extern void								switch_context();
extern void*							get_cp_stack_pointer();

#endif
