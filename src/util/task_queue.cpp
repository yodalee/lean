/*
Copyright (c) 2016 Microsoft Corporation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

Author: Gabriel Ebner
*/
#include <string>
#include "util/task_queue.h"

namespace lean {

std::string generic_task::description() const {
    std::ostringstream out;
    description(out);
    return out.str();
}

generic_task::generic_task() : m_mod(get_current_module()), m_pos(get_current_task_pos()) {}

generic_task_result_cell::generic_task_result_cell(generic_task * t) :
        m_rc(0), m_task(t), m_desc(t->description()) {}

void generic_task_result_cell::clear_task() {
    if (m_task) {
        delete m_task;
        m_task = nullptr;
    }
}

LEAN_THREAD_PTR(task_queue, g_tq);
scope_global_task_queue::scope_global_task_queue(task_queue * tq) {
    m_old_tq = g_tq;
    g_tq = tq;
}
scope_global_task_queue::~scope_global_task_queue() {
    g_tq = m_old_tq;
}
task_queue & get_global_task_queue() {
    return *g_tq;
}

task_cancellation_exception::task_cancellation_exception(generic_task_result const & cancelled_task) {
    std::ostringstream out;
    if (cancelled_task) {
        out << "task cancelled: " << cancelled_task.description();
    } else {
        out << "task cancelled";
    }
    m_msg = out.str();
}

char const *task_cancellation_exception::what() const noexcept {
    return m_msg.c_str();
}

LEAN_THREAD_PTR(module_id, g_cur_mod);
LEAN_THREAD_PTR(pos_info, g_cur_task_pos);
scoped_task_context::scoped_task_context(module_id const & mod, pos_info const & pos) : m_id(mod), m_pos(pos) {
    m_old_id = g_cur_mod;
    m_old_pos = g_cur_task_pos;
    g_cur_mod = &m_id;
    g_cur_task_pos = &m_pos;
}
scoped_task_context::~scoped_task_context() {
    g_cur_mod = m_old_id;
    g_cur_task_pos = m_old_pos;
}

module_id get_current_module() { return *g_cur_mod; }
pos_info get_current_task_pos() { return *g_cur_task_pos; }

}
